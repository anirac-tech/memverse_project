import 'dart:developer';
import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Provider for the FeedbackService
final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService();
});

// Top-level function required for compute.
// Handles deleting the file in a background isolate.
Future<void> _deleteFileInBackground(String path) async {
  const logName = 'FeedbackService(BG)'; // Differentiate background logs
  try {
    final tempFile = File(path);
    // Check existence and delete within the background isolate
    // ignore: avoid_slow_async_io // Still needed within compute's isolate
    if (await tempFile.exists()) {
      // ignore: avoid_slow_async_io // Still needed within compute's isolate
      await tempFile.delete();
      log('Deleted temporary screenshot file in background: $path', name: logName);
    } else {
      log('Temporary file did not exist when background deletion ran: $path', name: logName);
    }
  } catch (e, stack) {
    log(
      'Error deleting temporary screenshot file in background: $e',
      stackTrace: stack, // Include stack trace for background errors
      name: logName,
    );
    // Consider if further error handling/reporting is needed from background
  }
}

/// Service class to handle feedback submission logic.
class FeedbackService {
  static const _logName = 'FeedbackService';

  /// Truncates text to a maximum length, adding ellipsis if truncated.
  @visibleForTesting
  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    // Find the last space within the maxLength to avoid cutting words
    var truncated = text.substring(0, maxLength);
    final lastSpace = truncated.lastIndexOf(' ');
    if (lastSpace > 0 && lastSpace > maxLength - 20) {
      // Ensure reasonable word break
      truncated = truncated.substring(0, lastSpace);
    }
    return '$truncated...';
  }

  /// Generates a subject line for the feedback email/share intent.
  @visibleForTesting
  String generateSubject(String feedbackText) {
    const prefix = 'Memverse Feedback: ';
    // Limit subject to ~50 chars after prefix for better email client compatibility
    const maxFeedbackLength = 50;
    final truncatedFeedback = truncateText(feedbackText.replaceAll('\n', ' '), maxFeedbackLength);
    return '$prefix$truncatedFeedback';
  }

  /// Saves the screenshot to a temporary file. Returns the file path or null on error.
  Future<String?> _saveScreenshot(Uint8List screenshotBytes) async {
    try {
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${dir.path}/memverse_feedback_$timestamp.png';
      final file = File(path);
      // ignore: avoid_slow_async_io
      // Writing a small screenshot file is unlikely to block the main thread significantly.
      await file.writeAsBytes(screenshotBytes);
      log('Screenshot saved to: $path', name: _logName);
      return path;
    } catch (e, stack) {
      log('Error saving screenshot: $e', stackTrace: stack, name: _logName);
      return null;
    }
  }

  /// Attempts to share feedback text along with a screenshot file.
  Future<bool> _tryShareWithScreenshot(String path, String text, String subject) async {
    try {
      // ignore: deprecated_member_use
      final result = await Share.shareXFiles([XFile(path)], text: text, subject: subject);
      log('Share XFiles completed with status: ${result.status.name}', name: _logName);
      return result.status != ShareResultStatus.unavailable;
    } catch (e, stack) {
      log('Error sharing feedback with screenshot: $e', stackTrace: stack, name: _logName);
      debugPrint('Error while sharing feedback with screenshot: $e');
      return false;
    }
  }

  /// Attempts to share only the feedback text.
  Future<bool> _tryShareTextOnly(String text, String subject) async {
    try {
      // ignore: deprecated_member_use
      final result = await Share.share(text, subject: subject);
      log('Fallback text share completed with status: ${result.status.name}', name: _logName);
      return result.status != ShareResultStatus.unavailable;
    } catch (e, stack) {
      log('Error during fallback text share: $e', stackTrace: stack, name: _logName);
      debugPrint('Error during fallback text share: $e');
      return false;
    }
  }

  /// Cleans up (deletes) the temporary screenshot file using compute.
  Future<void> _cleanupScreenshot(String? path) async {
    if (path == null) return;

    // Use compute to run file deletion in a background isolate
    // This avoids the avoid_slow_async_io lint in the main isolate.
    try {
      await compute(_deleteFileInBackground, path);
      log('Scheduled background deletion for: $path', name: _logName);
    } catch (e, stack) {
      // Log error if scheduling deletion fails.
      // Actual deletion errors are logged in _deleteFileInBackground.
      log('Error scheduling background file deletion: $e', stackTrace: stack, name: _logName);
    }
  }

  /// Shows a SnackBar with the given message.
  void _showSnackbar(BuildContext context, String message) {
    // Check mounted state here as this method might be called from various places
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Main method to handle the feedback submission process.
  Future<void> handleFeedbackSubmission(BuildContext context, UserFeedback feedback) async {
    log(
      'Handling feedback. Text length: ${feedback.text.length}, Screenshot bytes: ${feedback.screenshot.length}',
      name: _logName,
    );

    String? screenshotPath;
    try {
      screenshotPath = await _saveScreenshot(feedback.screenshot);

      if (screenshotPath != null) {
        final subject = generateSubject(feedback.text);

        final sharedWithScreenshot = await _tryShareWithScreenshot(
          screenshotPath,
          feedback.text,
          subject,
        );

        if (sharedWithScreenshot) {
          return; // Success
        } else {
          log('Sharing with screenshot failed, attempting text-only share.', name: _logName);
          if (!context.mounted) return; // Early exit if not mounted
          final sharedTextOnly = await _tryShareTextOnly(feedback.text, subject);
          if (!context.mounted) return; // Exit if context became invalid during await
          if (sharedTextOnly) {
            _showSnackbar(context, 'Sharing screenshot failed, shared text only');
          } else {
            _showSnackbar(context, 'Failed to share feedback');
          }
        }
      } else {
        log('Screenshot saving failed, attempting text-only share.', name: _logName);
        final subject = generateSubject(feedback.text);
        if (!context.mounted) return; // Early exit if not mounted
        final sharedTextOnly = await _tryShareTextOnly(feedback.text, subject);
        if (!context.mounted) return; // Exit if context became invalid during await
        if (!sharedTextOnly) {
          _showSnackbar(context, 'Failed to share feedback (screenshot save failed)');
        }
      }
    } finally {
      await _cleanupScreenshot(screenshotPath);
    }
  }
}
