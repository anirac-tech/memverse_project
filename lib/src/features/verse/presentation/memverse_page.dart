import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';
import 'package:memverse/src/features/verse/presentation/feedback_service.dart';
import 'package:memverse/src/features/verse/presentation/widgets/question_section.dart';
import 'package:memverse/src/features/verse/presentation/widgets/stats_and_history_section.dart';
import 'package:memverse/src/utils/app_logger.dart';

// Key constants for Patrol tests
const memversePageScaffoldKey = ValueKey('memverse_page_scaffold');
const feedbackButtonKey = ValueKey('feedback_button');

// TODO(neiljaywarner): Riverpod 2 or riverpod 3 and provider not instance
// This will be addressed in a future update - kept as-is for PR #7

final verseListProvider = FutureProvider<List<Verse>>(
  (ref) async => ref.watch(verseRepositoryProvider).getVerses(),
);

class MemversePage extends HookConsumerWidget {
  const MemversePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVerseIndex = useState(0);
    final cycleCount = useState(0); // Track how many times we've cycled through the list
    final answerController = useTextEditingController();
    final answerFocusNode = useFocusNode();
    final hasSubmittedAnswer = useState(false);
    final isAnswerCorrect = useState(false);
    final pastQuestions = useState<List<String>>([]);

    final l10n = AppLocalizations.of(context);
    final pageTitle = l10n.referenceTest;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final versesAsync = ref.watch(verseListProvider);
    final analyticsService = ref.read(analyticsServiceProvider);

    useEffect(() {
      answerFocusNode.requestFocus();
      // Track app opened/practice session start
      analyticsService
        ..trackAppOpened()
        ..trackPracticeSessionStart();

      // Web-specific tracking
      if (kIsWeb) {
        analyticsService.trackWebPageView('memverse_practice_page');
        // Track web browser info if available
        // Note: In a real app, you might use dart:html to get navigator.userAgent
        analyticsService.trackWebBrowserInfo('web_flutter_app');
      }

      return null;
    }, const []);

    void loadNextVerse() {
      answerController.clear();
      hasSubmittedAnswer.value = false;
      isAnswerCorrect.value = false;

      // Update the current verse index only if we have verses data
      versesAsync.whenData((verses) {
        // Check if we've reached the end of available verses
        if (currentVerseIndex.value + 1 < verses.length) {
          currentVerseIndex.value++;
        } else {
          // Reset to the first verse when we reach the end
          currentVerseIndex.value = 0;
          cycleCount.value++;

          // Track verse list cycling
          analyticsService.trackVerseListCycled(verses.length, cycleCount.value);
        }

        // Track verse displayed
        if (verses.isNotEmpty) {
          final nextIndex = currentVerseIndex.value + 1 < verses.length
              ? currentVerseIndex.value + 1
              : 0;
          final nextVerse = verses[nextIndex];
          analyticsService.trackVerseDisplayed(nextVerse.reference);
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid reference format'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
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

        final isCorrect = booksMatch && chapterVerseMatch;
        final isNearlyCorrect = !isCorrect && (booksMatch || chapterVerseMatch);

        hasSubmittedAnswer.value = true;
        isAnswerCorrect.value = isCorrect;

        // Track verse answer
        if (isCorrect) {
          analyticsService.trackVerseCorrect(expectedReference);
        } else if (isNearlyCorrect) {
          analyticsService.trackVerseNearlyCorrect(expectedReference, userAnswer);
        } else {
          analyticsService.trackVerseIncorrect(expectedReference, userAnswer);
        }

        final feedback = isCorrect
            ? '$userAnswer-[$expectedReference] Correct!'
            : '$userAnswer-[$expectedReference] Incorrect';

        pastQuestions.value = [...pastQuestions.value, feedback];

        final detailedFeedback = isCorrect
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
    }

    return Scaffold(
      key: memversePageScaffoldKey,
      appBar: AppBar(
        title: Text(isSmallScreen ? pageTitle : 'Memverse $pageTitle'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // coverage:ignore-start
          IconButton(
            key: feedbackButtonKey,
            icon: const Icon(Icons.feedback_outlined),
            tooltip: 'Send Feedback',
            onPressed: () {
              AppLogger.d('Feedback button pressed');

              // Track feedback trigger
              analyticsService.trackFeedbackTrigger();

              final feedbackService = ref.read(feedbackServiceProvider);
              BetterFeedback.of(context).show((feedback) async {
                await feedbackService.handleFeedbackSubmission(context, feedback);
              });
            },
          ),
          // coverage:ignore-end
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
          child: isSmallScreen
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
                        l10n: l10n,
                        answerController: answerController,
                        answerFocusNode: answerFocusNode,
                        hasSubmittedAnswer: hasSubmittedAnswer.value,
                        isAnswerCorrect: isAnswerCorrect.value,
                        onSubmitAnswer: submitAnswer,
                      ),
                    ),
                    const SizedBox(height: 24),
                    StatsAndHistorySection(l10n: l10n, pastQuestions: pastQuestions.value),
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
                          currentVerseIndex: versesAsync.maybeWhen(
                            data: (verses) => currentVerseIndex.value < verses.length
                                ? currentVerseIndex.value
                                : 0,
                            orElse: () => 0,
                          ),
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
                      child: StatsAndHistorySection(l10n: l10n, pastQuestions: pastQuestions.value),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
