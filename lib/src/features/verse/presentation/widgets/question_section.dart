import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/features/verse/presentation/widgets/verse_card.dart';
import 'package:memverse/src/features/verse/presentation/widgets/verse_reference_form.dart';

class QuestionSection extends HookConsumerWidget {
  const QuestionSection({
    required this.versesAsync,
    required this.currentVerseIndex,
    required this.questionNumber,
    required this.l10n,
    required this.answerController,
    required this.answerFocusNode,
    required this.hasSubmittedAnswer,
    required this.isAnswerCorrect,
    required this.onSubmitAnswer,
    super.key,
  });

  final AsyncValue<List<Verse>> versesAsync;
  final int currentVerseIndex;
  final int questionNumber;
  final AppLocalizations l10n;
  final TextEditingController answerController;
  final FocusNode answerFocusNode;
  final bool hasSubmittedAnswer;
  final bool isAnswerCorrect;
  final void Function(String) onSubmitAnswer;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        padding: const EdgeInsets.only(bottom: 12),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 18, color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: '${l10n.question}: '),
              TextSpan(
                text: '$questionNumber',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),

      // Verse text container
      Flexible(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 50, maxHeight: 150),
          child: versesAsync.when(
            data: (verses) => VerseCard(verse: verses[currentVerseIndex]),
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
            error:
                (error, stackTrace) => Center(
                  child: Text(
                    'Error loading verses: $error',
                    style: const TextStyle(color: Colors.red),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
          ),
        ),
      ),

      const SizedBox(height: 16),

      // Reference form
      versesAsync.maybeWhen(
        data:
            (verses) => VerseReferenceForm(
              expectedReference: verses[currentVerseIndex].reference,
              l10n: l10n,
              answerController: answerController,
              answerFocusNode: answerFocusNode,
              hasSubmittedAnswer: hasSubmittedAnswer,
              isAnswerCorrect: isAnswerCorrect,
              onSubmitAnswer: onSubmitAnswer,
            ),
        orElse: () => const SizedBox.shrink(),
      ),
    ],
  );
}
