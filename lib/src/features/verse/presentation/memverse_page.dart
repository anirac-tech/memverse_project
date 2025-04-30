import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';
import 'package:memverse/src/features/verse/presentation/widgets/question_section.dart';
import 'package:memverse/src/features/verse/presentation/widgets/stats_and_history_section.dart';

// TODO(neiljaywarner): Riverpod 2 or riverpod 3 and provider not instance
// This will be addressed in a future update - kept as-is for PR #7
final verseListProvider = FutureProvider<List<Verse>>(
  (ref) async => ref.watch(verseRepositoryProvider).getVerses(),
);

class MemversePage extends HookConsumerWidget {
  const MemversePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsync = ref.watch(verseListProvider);
    final currentVerseIndex = useState(0);
    final questionNumber = useState(1);
    final answerController = useTextEditingController();
    final answerFocusNode = useFocusNode();
    final hasSubmittedAnswer = useState(false);
    final isAnswerCorrect = useState(false);
    final progress = useState<double>(0);
    final totalCorrect = useState<int>(0);
    final totalAnswered = useState<int>(0);
    final overdueReferences = useState(5);
    final pastQuestions = useState<List<String>>([]);

    final l10n = AppLocalizations.of(context);
    final pageTitle = l10n.referenceTest;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    useEffect(() {
      answerFocusNode.requestFocus();
      return null;
    }, const [],);

    void loadNextVerse() {
      versesAsync.whenData((verses) {
        answerController.clear();
        hasSubmittedAnswer.value = false;
        isAnswerCorrect.value = false;

        questionNumber.value++;
        // Reset to first verse if we've reached the end of the list
        if (currentVerseIndex.value >= verses.length - 1) {
          currentVerseIndex.value = 0;
        } else {
          currentVerseIndex.value++;
        }
      });
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
        // coverage:ignore-start
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid reference format'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
        // coverage:ignore-end
      }

      final userAnswer = answerController.text.trim();

      final bookChapterVersePattern = RegExp(
        r'^(([1-3]\s+)?[A-Za-z]+(\s+[A-Za-z]+)*)\s+(\d+):(\d+)(-\d+)?$',
      );

      final userMatch = bookChapterVersePattern.firstMatch(userAnswer);
      final expectedMatch = bookChapterVersePattern.firstMatch(expectedReference);

      if (userMatch != null && expectedMatch != null) {
        final userBookName = userMatch.group(1)?.trim() ?? '';
        final userChapterVerse = '${userMatch.group(4)}:${userMatch.group(5)}';

        final expectedBookName = expectedMatch.group(1)?.trim() ?? '';
        final expectedChapterVerse = '${expectedMatch.group(4)}:${expectedMatch.group(5)}';

        final userStandardBook = VerseReferenceValidator.getStandardBookName(userBookName);
        final expectedStandardBook = VerseReferenceValidator.getStandardBookName(expectedBookName);

        final booksMatch = userStandardBook.toLowerCase() == expectedStandardBook.toLowerCase();
        final chapterVerseMatch = userChapterVerse == expectedChapterVerse;

        // coverage:ignore-start
        final isCorrect = booksMatch && chapterVerseMatch;

        hasSubmittedAnswer.value = true;
        // coverage:ignore-end
        isAnswerCorrect.value = isCorrect;

        if (isCorrect) {
          totalCorrect.value++;
          if (overdueReferences.value > 0) {
            overdueReferences.value--;
          }
        }

        totalAnswered.value++;
        progress.value =
            totalAnswered.value > 0 ? (totalCorrect.value * 100 / totalAnswered.value) : 0;

        // coverage:ignore-start
        final feedback =
            isCorrect
                ? '$userAnswer-[$expectedReference] Correct!'
                : '$userAnswer-[$expectedReference] Incorrect';

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
        // coverage:ignore-end
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
            },
            tooltip: 'Logout',
          ),
        ],
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
          child:
              isSmallScreen
                  ? Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                          minHeight: 250,
                        ),
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
