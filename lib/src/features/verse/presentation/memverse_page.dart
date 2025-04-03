import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

// TODO(neiljaywarner): Riverpod 2 oe riverpod 3 and provider not instance
final verseListProvider = FutureProvider<List<Verse>>((ref) async {
  return VerseRepositoryProvider.instance.getVerses();
});

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
      //ignore: require_trailing_commas
    }, const []);

    void loadNextVerse() {
      // Reset the answer field and submission state
      answerController.clear();
      hasSubmittedAnswer.value = false;
      isAnswerCorrect.value = false;

      // Increment question number
      questionNumber.value++;

      // Move to next verse
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
      // Update progress as percentage of correct answers
      progress.value =
          totalAnswered.value > 0 ? (totalCorrect.value / totalAnswered.value) * 100 : 0;

      // Add to history
      final feedback =
          isCorrect
              ? '${answerController.text}-[$expectedReference] Correct!'
              : '${answerController.text}-[$expectedReference] Incorrect';

      final newPastQuestions = [...pastQuestions.value, feedback];
      if (newPastQuestions.length > 5) {
        newPastQuestions.removeAt(0);
      }
      pastQuestions.value = newPastQuestions;

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

      // Move to next verse after delay
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
          child:
              isSmallScreen
                  ?
                  //coverage:ignore-start
                  Column(
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
                  //coverage:ignore-end
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
      SizedBox(
        height: 180,
        child: versesAsync.when(
          data: (verses) {
            final verse =
                currentVerseIndex < verses.length ? verses[currentVerseIndex] : verses.last;
            return VerseCard(verse: verse);
          },
          loading: () => const Center(child: CircularProgressIndicator.adaptive()),
          error:
              (error, stackTrace) => Center(
                child: Text(
                  'Error loading verses: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
        ),
      ),

      const SizedBox(height: 24),

      // Reference form
      versesAsync.maybeWhen(
        data: (verses) {
          final verse = currentVerseIndex < verses.length ? verses[currentVerseIndex] : verses.last;
          return VerseReferenceForm(
            expectedReference: verse.reference,
            l10n: l10n,
            answerController: answerController,
            answerFocusNode: answerFocusNode,
            hasSubmittedAnswer: hasSubmittedAnswer,
            isAnswerCorrect: isAnswerCorrect,
            onSubmitAnswer: onSubmitAnswer,
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
    ],
  );
}

class VerseCard extends StatelessWidget {
  const VerseCard({required this.verse, super.key});

  final Verse verse;

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('refTestVerse'),
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(5),
      color: Colors.grey[50],
    ),
    child: Stack(
      children: [
        // Scrollable verse text
        Positioned.fill(
          bottom: 25,
          child: SingleChildScrollView(
            child: Text(
              verse.text,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, height: 1.5),
            ),
          ),
        ),

        // Attribution text
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              verse.translation,
              style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

class VerseReferenceValidator {
  static final List<String> bookSuggestions = <String>[
    'Genesis',
    'Exodus',
    'Leviticus',
    'Numbers',
    'Deuteronomy',
    'Joshua',
    'Judges',
    'Ruth',
    '1 Samuel',
    '2 Samuel',
    '1 Kings',
    '2 Kings',
    '1 Chronicles',
    '2 Chronicles',
    'Ezra',
    'Nehemiah',
    'Esther',
    'Job',
    'Psalm',
    'Proverbs',
    'Ecclesiastes',
    'Song of Songs',
    'Isaiah',
    'Jeremiah',
    'Lamentations',
    'Ezekiel',
    'Daniel',
    'Hosea',
    'Joel',
    'Amos',
    'Obadiah',
    'Jonah',
    'Micah',
    'Nahum',
    'Habakkuk',
    'Zephaniah',
    'Haggai',
    'Zechariah',
    'Malachi',
    'Matthew',
    'Mark',
    'Luke',
    'John',
    'Acts',
    'Romans',
    '1 Corinthians',
    '2 Corinthians',
    'Galatians',
    'Ephesians',
    'Philippians',
    'Colossians',
    '1 Thessalonians',
    '2 Thessalonians',
    '1 Timothy',
    '2 Timothy',
    'Titus',
    'Philemon',
    'Hebrews',
    'James',
    '1 Peter',
    '2 Peter',
    '1 John',
    '2 John',
    '3 John',
    'Jude',
    'Revelation',
  ];

  static bool isValid(String text) {
    if (text.isEmpty) {
      return false;
    }

    final bookChapterVersePattern = RegExp(
      r'^(([1-3]\s+)?[A-Za-z]+(\s+[A-Za-z]+)*)\s+(\d+):(\d+)(-\d+)?$',
    );

    if (bookChapterVersePattern.hasMatch(text)) {
      final match = bookChapterVersePattern.firstMatch(text);
      final bookName = match?.group(1)?.trim() ?? '';

      return bookSuggestions.any((book) => book.toLowerCase() == bookName.toLowerCase());
    }
    return false;
  }
}

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
          color:
              showSuccessStyle
                  ? Colors.green
                  : showErrorStyle
                  ? Colors.orange
                  : Colors.grey[300]!,
          width: (showSuccessStyle || showErrorStyle) ? 2.0 : 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:
              showSuccessStyle
                  ? Colors.green
                  : showErrorStyle
                  ? Colors.orange
                  : Colors.grey[300]!,
          width: (showSuccessStyle || showErrorStyle) ? 2.0 : 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:
              showSuccessStyle
                  ? Colors.green
                  : showErrorStyle
                  ? Colors.orange
                  : Colors.blue,
          width: 2,
        ),
      ),
      hintText: l10n.enterReferenceHint,
      helperText:
          showSuccessStyle
              ? l10n.correct
              : showErrorStyle
              ? l10n.notQuiteRight(expectedReference)
              : l10n.referenceFormat,
      helperStyle: TextStyle(
        color:
            showSuccessStyle
                ? Colors.green
                : showErrorStyle
                ? Colors.orange
                : Colors.grey[600],
        fontWeight: (showSuccessStyle || showErrorStyle) ? FontWeight.bold : FontWeight.normal,
      ),
      suffixIcon:
          showSuccessStyle
              ? const Icon(Icons.check_circle, color: Colors.green)
              : showErrorStyle
              ? const Icon(Icons.cancel, color: Colors.orange)
              : null,
      filled: showSuccessStyle || showErrorStyle,
      fillColor:
          showSuccessStyle
              ? Colors.green.withAlpha(25)
              : showErrorStyle
              ? Colors.orange.withAlpha(25)
              : null,
    );
  }
}

class StatsAndHistorySection extends StatelessWidget {
  const StatsAndHistorySection({
    required this.progress,
    required this.totalCorrect,
    required this.totalAnswered,
    required this.l10n,
    required this.overdueReferences,
    required this.pastQuestions,
    this.isLoading = false,
    this.isErrored = false,
    this.isValidated = false,
    this.error,
    this.validationError,
    super.key,
  });

  final double progress;
  final int totalCorrect;
  final int totalAnswered;
  final AppLocalizations l10n;
  final bool isLoading;
  final bool isErrored;
  final bool isValidated;
  final int overdueReferences;
  final List<String> pastQuestions;
  final String? error;
  final String? validationError;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 160,
              child: Center(
                child: ReferenceGauge(
                  progress: progress,
                  totalCorrect: totalCorrect,
                  totalAnswered: totalAnswered,
                  l10n: l10n,
                  isLoading: isLoading,
                  isErrored: isErrored,
                  isValidated: isValidated,
                  error: error,
                  validationError: validationError,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[100],
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(
                    '$overdueReferences',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    l10n.referencesDueToday,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: l10n),
    ],
  );
}

class QuestionHistoryWidget extends StatelessWidget {
  const QuestionHistoryWidget({required this.pastQuestions, required this.l10n, super.key});

  final List<String> pastQuestions;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.priorQuestions,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          key: const Key('past-questions'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                pastQuestions.isEmpty
                    ? [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(l10n.noPreviousQuestions),
                      ),
                    ]
                    : pastQuestions
                        .map(
                          (feedback) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              feedback,
                              style: TextStyle(
                                color:
                                    feedback.contains(' Correct!') ? Colors.green : Colors.orange,
                                fontWeight:
                                    pastQuestions.indexOf(feedback) == pastQuestions.length - 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        )
                        .toList(),
          ),
        ),
      ],
    ),
  );
}

class ReferenceGauge extends StatelessWidget {
  const ReferenceGauge({
    required this.progress,
    required this.totalCorrect,
    required this.totalAnswered,
    required this.l10n,
    this.isLoading = false,
    this.isErrored = false,
    this.isValidated = false,
    this.error,
    this.validationError,
    super.key,
  });

  final double progress;
  final int totalCorrect;
  final int totalAnswered;
  final AppLocalizations l10n;
  final bool isLoading;
  final bool isErrored;
  final bool isValidated;
  final String? error;
  final String? validationError;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isErrored) {
      return Text(error ?? '', style: const TextStyle(color: Colors.red));
    }

    if (isValidated) {
      return Text(validationError ?? '', style: const TextStyle(color: Colors.red));
    }

    Color gaugeColor;
    if (progress < 33) {
      gaugeColor = Colors.red[400]!;
    } else if (progress < 66) {
      gaugeColor = Colors.orange[400]!;
    } else {
      gaugeColor = Colors.green[400]!;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Reference Progress', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 10),
        SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress / 100,
                strokeWidth: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${progress.round()}%',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text('$totalCorrect/$totalAnswered', style: const TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
