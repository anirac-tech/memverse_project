import 'dart:io';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  // Helper function to write image bytes to a temporary file
  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final output = await getTemporaryDirectory();
    final screenshotFilePath = '${output.path}/feedback.png';
    final screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutAppBarTitle)),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            BetterFeedback.of(context).show((UserFeedback feedback) async {
              // Handle feedback submission
              try {
                final screenshotFilePath = await _writeImageToStorage(feedback.screenshot);

                final screenshotXFile = XFile(screenshotFilePath);

                await SharePlus.instance.share(
                  ShareParams(
                    text: feedback.text,
                    files: [screenshotXFile],
                    // subject: l10n.feedbackEmailSubject, // Optional: Subject for email sharing
                  ),
                );
              } catch (e) {
                if (kDebugMode) {
                  print('Error sharing feedback: $e');
                }
                // Optionally show an error message to the user
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.feedbackErrorSnackbar)));
              }
            });
          },
          child: Text(l10n.sendFeedbackButtonLabel),
        ),
      ),
    );
  }
}
