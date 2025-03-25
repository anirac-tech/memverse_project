import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';

final verseListProvider = FutureProvider<List<Verse>>((ref) async {
  return VerseRepositoryProvider.instance.getVerses();
});

class MemversePage extends ConsumerStatefulWidget {
  const MemversePage({super.key});

  @override
  ConsumerState<MemversePage> createState() => _MemversePageState();
}

class _MemversePageState extends ConsumerState<MemversePage> {
  int currentVerseIndex = 0;
  String pageTitle = 'Reference Test';
  int questionNumber = 1;
  final TextEditingController answerController = TextEditingController();
  bool hasSubmittedAnswer = false;
  bool isAnswerCorrect = false;
  double referenceRecallGrade = 60;
  int overdueReferences = 5;
  final List<String> pastQuestions = [];
  final FocusNode answerFocusNode = FocusNode();
  late AppLocalizations _l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _l10n = AppLocalizations.of(context);
    if (_l10n != null) {
      pageTitle = _l10n.referenceTest;
    } else {
      // Fallback if localization is not available
      pageTitle = 'Reference Test';
    }
  }

  @override
  void initState() {
    super.initState();
    answerFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

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
                color: Colors.grey.withOpacity(0.3),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: _buildQuestionSection(),
                    ),
                    const SizedBox(height: 24),
                    _buildStatsAndHistorySection(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: _buildQuestionSection(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatsAndHistorySection()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection() {
    final versesAsync = ref.watch(verseListProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 12),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: <TextSpan>[
                TextSpan(text: '${_l10n.question}: '),
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
              final verse = verses[currentVerseIndex % verses.length];
              return _buildVerseCard(verse);
            },
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
            error: (error, stackTrace) => Center(
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
            final verse = verses[currentVerseIndex % verses.length];
            return _buildVerseReferenceForm(verse.reference);
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
  
  Widget _buildVerseCard(Verse verse) {
    return Container(
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVerseReferenceForm(String expectedReference) {
    bool isReferenceValid = true;
    String validationMessage = '';
    
    final List<String> bookSuggestions = [
      'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy',
      'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
      '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles',
      'Ezra', 'Nehemiah', 'Esther', 'Job', 'Psalm', 'Proverbs',
      'Ecclesiastes', 'Song of Songs', 'Isaiah', 'Jeremiah',
      'Lamentations', 'Ezekiel', 'Daniel', 'Hosea', 'Joel',
      'Amos', 'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk',
      'Zephaniah', 'Haggai', 'Zechariah', 'Malachi', 'Matthew',
      'Mark', 'Luke', 'John', 'Acts', 'Romans', '1 Corinthians',
      '2 Corinthians', 'Galatians', 'Ephesians', 'Philippians',
      'Colossians', '1 Thessalonians', '2 Thessalonians',
      '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews',
      'James', '1 Peter', '2 Peter', '1 John', '2 John', '3 John',
      'Jude', 'Revelation',
    ];
    
    bool isValidVerseRef(String text) {
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
    
    void submitAnswer() {
      if (!isValidVerseRef(answerController.text)) {
        return;
      }
      
      final userAnswer = answerController.text.trim().toLowerCase();
      final isCorrect = userAnswer == expectedReference.toLowerCase();
      
      setState(() {
        hasSubmittedAnswer = true;
        isAnswerCorrect = isCorrect;
        
        if (isCorrect) {
          referenceRecallGrade = (referenceRecallGrade + 100) / 2;
          if (referenceRecallGrade > 100) referenceRecallGrade = 100;
          if (overdueReferences > 0) {
            overdueReferences--;
          }
        }
        
        // Add to history
        final feedback = isCorrect 
            ? '${answerController.text}-[$expectedReference] Correct!' 
            : '${answerController.text}-[$expectedReference] Incorrect';
        pastQuestions.add(feedback);
        if (pastQuestions.length > 5) {
          pastQuestions.removeAt(0);
        }
      });
      
      final detailedFeedback = isCorrect
          ? _l10n.correctReferenceIdentification(expectedReference)
          : _l10n.notQuiteRight(expectedReference);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(detailedFeedback),
          backgroundColor: isCorrect ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Move to next verse after delay
      Future.delayed(const Duration(milliseconds: 1500), _loadNextVerse);
    }
    
    InputDecoration getInputDecoration() {
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
        hintText: _l10n.enterReferenceHint,
        errorText: isReferenceValid ? null : validationMessage,
        helperText: showSuccessStyle
            ? _l10n.correct
            : showErrorStyle
            ? _l10n.notQuiteRight(expectedReference)
            : _l10n.referenceFormat,
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
            ? Colors.green.withOpacity(0.1)
            : showErrorStyle
            ? Colors.orange.withOpacity(0.1)
            : null,
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reference label
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(_l10n.reference, style: const TextStyle(fontSize: 18, color: Colors.black)),
        ),

        // Reference input form
        TextField(
          controller: answerController,
          focusNode: answerFocusNode,
          decoration: getInputDecoration(),
          onSubmitted: (value) => submitAnswer(),
        ),

        const SizedBox(height: 16),

        // Submit button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            key: const Key('submit-ref'),
            onPressed: submitAnswer,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(_l10n.submit),
          ),
        ),
      ],
    );
  }

  void _loadNextVerse() {
    setState(() {
      // Reset the answer field and submission state
      answerController.clear();
      hasSubmittedAnswer = false;
      isAnswerCorrect = false;

      // Increment question number
      questionNumber++;

      // Move to next verse
      currentVerseIndex++;
    });
  }

  Widget _buildStatsAndHistorySection() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(width: 200, height: 160, child: Center(child: _buildGauge())),
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
                      _l10n.referencesDueToday,
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _l10n.priorQuestions,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                key: const Key('past-questions'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pastQuestions.isEmpty
                      ? [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(_l10n.noPreviousQuestions),
                          ),
                        ]
                      : pastQuestions
                          .map(
                            (feedback) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                feedback,
                                style: TextStyle(
                                  color: feedback.contains(' Correct!')
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: pastQuestions.indexOf(feedback) ==
                                          pastQuestions.length - 1
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
        ),
      ],
    );
  }

  Widget _buildGauge() {
    Color gaugeColor;
    if (referenceRecallGrade < 33) {
      gaugeColor = Colors.red[400]!;
    } else if (referenceRecallGrade < 66) {
      gaugeColor = Colors.orange[400]!;
    } else {
      gaugeColor = Colors.green[400]!;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_l10n.referenceRecall, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 10),
        SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: referenceRecallGrade / 100,
                strokeWidth: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
              ),
              Text(
                '${referenceRecallGrade.toInt()}%',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    answerController.dispose();
    answerFocusNode.dispose();
    super.dispose();
  }
}