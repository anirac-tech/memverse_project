import 'dart:developer';
import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Provider for the FeedbackService
final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  // In the future, if this service needs other dependencies,
  // they can be obtained from 'ref' here.
  return FeedbackService();
});

/// Service class to handle feedback submission logic.
class FeedbackService {
  /// Truncates text to a maximum length, adding ellipsis if truncated.
  String _truncateText(String text, int maxLength) {
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
  String _generateSubject(String feedbackText) {
    const prefix = 'Memverse Feedback: ';
    // Limit subject to ~50 chars after prefix for better email client compatibility
    const maxFeedbackLength = 50;
    final truncatedFeedback = _truncateText(feedbackText.replaceAll('\n', ' '), maxFeedbackLength);
    return '$prefix$truncatedFeedback';
  }

  /// Saves the screenshot, shares feedback (text and screenshot), and cleans up.
  ///
  /// Falls back to sharing text only if screenshot handling fails.
  Future<void> handleFeedbackSubmission(
    BuildContext context, // Needed for ScaffoldMessenger
    UserFeedback feedback,
  ) async {
    log(
      'Handling feedback. Text length: ${feedback.text.length}, Screenshot bytes: ${feedback.screenshot.length}',
      name: 'FeedbackService',
    );

    File? screenshotFile;
    String? screenshotPath;
    try {
      // 1. Save screenshot to temporary file
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      screenshotPath = '${dir.path}/memverse_feedback_$timestamp.png';
      screenshotFile = File(screenshotPath);
      await screenshotFile.writeAsBytes(feedback.screenshot);
      log('Screenshot saved to: $screenshotPath', name: 'FeedbackService');

      // 2. Generate subject
      final subject = _generateSubject(feedback.text);

      // 3. Share both the text and screenshot using the static Share.shareXFiles
      // ignore: deprecated_member_use
      final result = await Share.shareXFiles(
        [XFile(screenshotPath)],
        text: feedback.text,
        subject: subject,
      );
      log('Share XFiles completed with result: ${result.raw}', name: 'FeedbackService');
    } catch (e, stack) {
      log(
        'Error preparing/sharing feedback with screenshot: $e',
        stackTrace: stack,
        name: 'FeedbackService',
      );
      debugPrint('Error while sharing feedback with screenshot: $e');

      // 4. Fallback to sharing just the text using the static Share.share
      try {
        final subject = _generateSubject(feedback.text); // Still generate subject
        // ignore: deprecated_member_use
        final result = await Share.share(feedback.text, subject: subject);
        log('Fallback text share completed with result: ${result.raw}', name: 'FeedbackService');
        // Notify user only if screenshot sharing failed but text succeeded
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sharing screenshot failed, shared text only')),
          );
        }
      } catch (shareError, shareStack) {
        log(
          'Error during fallback text share: $shareError',
          stackTrace: shareStack,
          name: 'FeedbackService',
        );
        debugPrint('Error during fallback text share: $shareError');
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to share feedback')));
        }
      }
    } finally {
      // 5. Clean up the temporary file
      try {
        if (screenshotPath != null) {
          final tempFile = File(screenshotPath);
          if (await tempFile.exists()) {
            await tempFile.delete();
            log('Deleted temporary screenshot file: $screenshotPath', name: 'FeedbackService');
          }
        }
      } catch (e) {
        log('Error deleting temporary screenshot file: $e', name: 'FeedbackService');
      }
    }
  }
}
