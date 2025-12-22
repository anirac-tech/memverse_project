import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';

class VerseReferenceForm extends HookWidget {
  const VerseReferenceForm({
    required this.expectedReference,
    required this.l10n,
    required this.answerController,
    required this.answerFocusNode,
    required this.hasSubmittedAnswer,
    required this.isAnswerCorrect,
    required this.onSubmitAnswer,
    super.key,
  });

  final String expectedReference;
  final AppLocalizations l10n;
  final TextEditingController answerController;
  final FocusNode answerFocusNode;
  final bool hasSubmittedAnswer;
  final bool isAnswerCorrect;
  final void Function(String) onSubmitAnswer;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Reference label
      Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(l10n.reference, style: const TextStyle(fontSize: 18, color: Colors.black)),
      ),

      // Reference input form
      TextField(
        controller: answerController,
        focusNode: answerFocusNode,
        decoration: _getInputDecoration(),
        onSubmitted: (_) => onSubmitAnswer(expectedReference),
      ),

      const SizedBox(height: 16),

      // Submit button
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          key: const Key('submit-ref'),
          onPressed: () => onSubmitAnswer(expectedReference),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(l10n.submit),
        ),
      ),
    ],
  );

  InputDecoration _getInputDecoration() {
    final showSuccessStyle = hasSubmittedAnswer && isAnswerCorrect;
    final showErrorStyle = hasSubmittedAnswer && !isAnswerCorrect;

    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle
              ? Colors.green
              : showErrorStyle
              ? Colors.orange
              : Colors.grey[300]!,
          width: (showSuccessStyle || showErrorStyle) ? 2.0 : 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle
              ? Colors.green
              : showErrorStyle
              ? Colors.orange
              : Colors.grey[300]!,
          width: (showSuccessStyle || showErrorStyle) ? 2.0 : 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle
              ? Colors.green
              : showErrorStyle
              ? Colors.orange
              : Colors.blue,
          width: 2,
        ),
      ),
      hintText: l10n.enterReferenceHint,
      helperText: showSuccessStyle
          ? l10n.correct
          : showErrorStyle
          ? l10n.notQuiteRight(expectedReference)
          : l10n.referenceFormat,
      helperStyle: TextStyle(
        color: showSuccessStyle
            ? Colors.green
            : showErrorStyle
            ? Colors.orange
            : Colors.grey[600],
        fontWeight: (showSuccessStyle || showErrorStyle) ? FontWeight.bold : FontWeight.normal,
      ),
      suffixIcon: showSuccessStyle
          ? const Icon(Icons.check_circle, color: Colors.green)
          : showErrorStyle
          ? const Icon(Icons.cancel, color: Colors.orange)
          : null,
      filled: showSuccessStyle || showErrorStyle,
      fillColor: showSuccessStyle
          ? Colors.green.withAlpha(25)
          : showErrorStyle
          ? Colors.orange.withAlpha(25)
          : null,
    );
  }
}
