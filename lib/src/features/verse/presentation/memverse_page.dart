import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';
import 'package:memverse/src/features/verse/presentation/widgets/question_section.dart';
import 'package:memverse/src/features/verse/presentation/widgets/stats_and_history_section.dart';

// TODO(neiljaywarner): Riverpod 2 or riverpod 3 and provider not instance
final verseListProvider = FutureProvider<List<Verse>>(
  (ref) async => VerseRepositoryProvider.instance.getVerses(),
);

class MemversePage extends HookConsumerWidget {
  const MemversePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVerseIndex = useState(0);
    final questionNumber = useState(1);
    final answerController = useTextEditingController();
    final answerFocusNode = useFocusNode();
    final hasSubmittedAnswer = useState(false);
    final isAnswerCorrect = useState(false);
    final progress = useState<double>(0);
    final totalAnswered = useState<int>(0);
    final totalCorrect = useState<int>(0);
    final overdueReferences = useState(5);
    final pastQuestions = useState<List<String>>([]);

    final l10n = AppLocalizations.of(context);
    final pageTitle = l10n.referenceTest;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final versesAsync = ref.watch(verseListProvider);

    useEffect(() {
      answerFocusNode.requestFocus();
      return null;
    }, const []);

    void loadNextVerse() {
      answerController.clear();
      hasSubmittedAnswer.value = false;
      isAnswerCorrect.value = false;

      questionNumber.value++;
      currentVerseIndex.value++;
    }

    void submitAnswer(String expectedReference) {
      if (answerController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.referenceCannotBeEmpty),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      if (!VerseReferenceValidator.isValid(answerController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid reference format'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      final userAnswer = answerController.text.trim().toLowerCase();
      final isCorrect = userAnswer == expectedReference.toLowerCase();

      hasSubmittedAnswer.value = true;
      isAnswerCorrect.value = isCorrect;

      if (isCorrect) {
        totalCorrect.value++;
        if (overdueReferences.value > 0) {
          overdueReferences.value--;
        }
      }

      totalAnswered.value++;
      progress.value =
          totalAnswered.value > 0 ? (totalCorrect.value / totalAnswered.value) * 100 : 0;

      final feedback =
          isCorrect
              ? '${answerController.text}-[$expectedReference] Correct!'
              : '${answerController.text}-[$expectedReference] Incorrect';

      pastQuestions.value = [...pastQuestions.value, feedback];

      final detailedFeedback =
          isCorrect
              ? l10n.correctReferenceIdentification(expectedReference)
              : l10n.notQuiteRight(expectedReference);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(detailedFeedback),
          backgroundColor: isCorrect ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );

      Future.delayed(const Duration(milliseconds: 1500), loadNextVerse);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(77),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          margin: const EdgeInsets.all(16),
          // TODO(neiljaywarner): get coverage on each of these
          child:
              isSmallScreen
                  // coverage:ignore-start
                  ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: QuestionSection(
                          versesAsync: versesAsync,
                          currentVerseIndex: currentVerseIndex.value,
                          questionNumber: questionNumber.value,
                          l10n: l10n,
                          answerController: answerController,
                          answerFocusNode: answerFocusNode,
                          hasSubmittedAnswer: hasSubmittedAnswer.value,
                          isAnswerCorrect: isAnswerCorrect.value,
                          onSubmitAnswer: submitAnswer,
                        ),
                      ),
                      const SizedBox(height: 24),
                      StatsAndHistorySection(
                        progress: progress.value,
                        totalCorrect: totalCorrect.value,
                        totalAnswered: totalAnswered.value,
                        l10n: l10n,
                        overdueReferences: overdueReferences.value,
                        pastQuestions: pastQuestions.value,
                      ),
                    ],
                  )
                  // coverage:ignore-end
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: QuestionSection(
                            versesAsync: versesAsync,
                            currentVerseIndex: currentVerseIndex.value,
                            questionNumber: questionNumber.value,
                            l10n: l10n,
                            answerController: answerController,
                            answerFocusNode: answerFocusNode,
                            hasSubmittedAnswer: hasSubmittedAnswer.value,
                            isAnswerCorrect: isAnswerCorrect.value,
                            onSubmitAnswer: submitAnswer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatsAndHistorySection(
                          progress: progress.value,
                          totalCorrect: totalCorrect.value,
                          totalAnswered: totalAnswered.value,
                          l10n: l10n,
                          overdueReferences: overdueReferences.value,
                          pastQuestions: pastQuestions.value,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
