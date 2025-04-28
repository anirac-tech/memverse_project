import 'dart:developer';
import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Handles the feedback submission process including saving screenshots and triggering the share dialog.
///
/// This function will save the screenshot to a temporary file and then share it along with the text.
/// If saving the screenshot fails, it falls back to sharing just the text.
///
/// [context] - The BuildContext for showing snackbars if needed
/// [feedback] - The UserFeedback object containing text and screenshot data
Future<void> handleFeedbackSubmission(BuildContext context, UserFeedback feedback) async {
  log(
    'Feedback submitted. Text length: ${feedback.text.length}, Screenshot bytes: ${feedback.screenshot.length}',
  );

  try {
    // Save screenshot to temporary file
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/memverse_feedback_$timestamp.png');
    await file.writeAsBytes(feedback.screenshot);
    log('Screenshot saved to: ${file.path}');

    // Share both the text and screenshot
    final result = await Share.shareXFiles(
      [XFile(file.path)],
      text: feedback.text,
      subject: 'Memverse App Feedback',
    );
    log('Share completed with status: ${result.status}');
  } catch (e, stack) {
    log('Error sharing feedback: $e', stackTrace: stack);

    // Show error in debug console
    debugPrint('Error while sharing feedback: $e');

    // Fallback to sharing just the text
    await Share.share(feedback.text, subject: 'Memverse App Feedback');
    log('Fallback share with text only completed');

    // Optionally show a snackbar to inform the user
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sharing with screenshot failed, shared text only')),
      );
    }
  }
}
