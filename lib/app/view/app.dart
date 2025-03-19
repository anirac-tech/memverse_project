import 'package:flutter/material.dart';
import 'package:memverse/l10n/l10n.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const RefTestScreen(),
    );
}

class RefTestScreen extends StatefulWidget {
  const RefTestScreen({super.key});

  @override
  _RefTestScreenState createState() => _RefTestScreenState();
}

class _RefTestScreenState extends State<RefTestScreen> {
  String pageTitle = 'Reference Test';
  int questionNumber = 1;
  String verseText = "In the beginning God created the heavens and the earth.";
  String verseAttribution = "NLT";
  String expectedReference = "Genesis 1:1";
  final TextEditingController answerController = TextEditingController();
  double referenceRecallGrade = 60.0;
  int overdueReferences = 5;
  List<String> pastQuestions = [];
  String memverseUserID = 'user123';
  int currentVerseIndex = 0;
  final List<Map<String, String>> versesList = [
    {
      "text": "In the beginning God created the heavens and the earth.",
      "reference": "Genesis 1:1"
    },
    {
      "text": "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
      "reference": "John 3:16"
    },
    {
      "text": "Trust in the LORD with all your heart; do not depend on your own understanding.",
      "reference": "Proverbs 3:5"
    },
    {
      "text": "I can do everything through Christ, who gives me strength.",
      "reference": "Philippians 4:13"
    },
    {
      "text": "And we know that God causes everything to work together for the good of those who love God and are called according to his purpose for them.",
      "reference": "Romans 8:28"
    }
  ];
  final List<String> bookSuggestions = [
    'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy', 'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
    '1 Kings', '2 Kings','1 Chronicles', '2 Chronicles', 'Ezra', 'Nehemiah', 'Esther', 'Job', 'Psalm', 'Proverbs',
    'Ecclesiastes', 'Song of Songs', 'Isaiah', 'Jeremiah', 'Lamentations', 'Ezekiel', 'Daniel', 'Hosea', 'Joel',
    'Amos', 'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk', 'Zephaniah', 'Haggai', 'Zechariah', 'Malachi', 'Matthew',
    'Mark', 'Luke', 'John', 'Acts', 'Romans', '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians', 'Philippians',
    'Colossians', '1 Thessalonians', '2 Thessalonians', '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews', 'James',
    '1 Peter', '2 Peter', '1 John', '2 John', '3 John', 'Jude', 'Revelation'
  ];
  final FocusNode answerFocusNode = FocusNode();

  int scoreRef(String answer) {
    return answer.toLowerCase().contains('genesis') ? 100 : 0;
  }

  double updateRefGrade(int questionScore) {
    setState(() {
      referenceRecallGrade = (referenceRecallGrade + questionScore) / 2;
    });
    return referenceRecallGrade;
  }

  bool isReferenceValid = true;
  String validationMessage = '';
  bool hasSubmittedAnswer = false;
  bool isAnswerCorrect = false;

  bool isValidVerseRef(String text) {
    if (text.isEmpty) {
      setState(() {
        isReferenceValid = false;
        validationMessage = 'Reference cannot be empty';
      });
      return false;
    }

    final bookChapterVersePattern = RegExp(
        r'^(([1-3]\s+)?[A-Za-z]+(\s+[A-Za-z]+)*)\s+(\d+):(\d+)(-\d+)?$'
    );

    if (bookChapterVersePattern.hasMatch(text)) {
      final match = bookChapterVersePattern.firstMatch(text);
      final bookName = match?.group(1)?.trim() ?? '';

      if (bookSuggestions.any((book) =>
      book.toLowerCase() == bookName.toLowerCase())) {
        setState(() {
          isReferenceValid = true;
          validationMessage = '';
        });
        return true;
      } else {
        setState(() {
          isReferenceValid = false;
          validationMessage = 'Invalid book name';
        });
        return false;
      }
    } else {
      setState(() {
        isReferenceValid = false;
        validationMessage = 'Format should be "Book Chapter:Verse"';
      });
      return false;
    }
  }

  String getDetailedFeedback(String userAnswer) {
    if (userAnswer.trim().isEmpty) {
      return 'Please enter a reference.';
    }

    if (userAnswer.trim().toLowerCase() == expectedReference.toLowerCase()) {
      return 'Great job! You correctly identified this verse as $expectedReference.';
    }

    // Try to parse the references
    final expectedParts = _parseReference(expectedReference);
    final userParts = _parseReference(userAnswer);

    // If either parsing fails, return a generic message
    if (expectedParts == null || userParts == null) {
      return 'That\'s not quite right. The correct reference is $expectedReference.';
    }

    // Debug output to verify parsing
    debugPrint('Expected: ${expectedParts.book}, ${expectedParts.chapter}:${expectedParts.verse}');
    debugPrint('User: ${userParts.book}, ${userParts.chapter}:${userParts.verse}');

    // Compare individual components
    bool bookMatch = userParts.book.toLowerCase() == expectedParts.book.toLowerCase();
    bool chapterMatch = userParts.chapter == expectedParts.chapter;
    bool verseMatch = userParts.verse == expectedParts.verse;

    if (bookMatch && chapterMatch && !verseMatch) {
      return 'You got the book and chapter right, but the verse is incorrect. The correct reference is $expectedReference.';
    } else if (bookMatch && !chapterMatch) {
      return 'You got the book right, but the chapter is incorrect. The correct reference is $expectedReference.';
    } else if (!bookMatch) {
      return 'The book you entered is incorrect. The correct reference is $expectedReference.';
    } else {
      // Fallback for unexpected cases
      return 'That\'s not quite right. The correct reference is $expectedReference.';
    }
  }

  // More reliable reference parsing
  ParsedReference? _parseReference(String reference) {
    try {
      final bookChapterVersePattern = RegExp(
          r'^(([1-3]\s+)?[A-Za-z]+(\s+[A-Za-z]+)*)\s+(\d+):(\d+)(-\d+)?$'
      );

      final match = bookChapterVersePattern.firstMatch(reference);
      if (match != null) {
        final book = match.group(1)?.trim() ?? '';
        final chapter = int.tryParse(match.group(4) ?? '0') ?? 0;
        final verse = int.tryParse(match.group(5) ?? '0') ?? 0;

        return ParsedReference(book, chapter, verse);
      }
    } catch (e) {
      debugPrint('Error parsing reference: $e');
    }
    return null;
  }

  String _generateFeedbackSummary(String userAnswer, String expectedRef) {
    final expectedParts = _parseReference(expectedRef);
    final userParts = _parseReference(userAnswer);

    if (userParts == null || expectedParts == null) {
      return "$userAnswer-[$expectedRef] Incorrect format";
    }

    if (userAnswer.trim().toLowerCase() == expectedRef.toLowerCase()) {
      return "$userAnswer-[$expectedRef] Correct!";
    }

    // Compare components
    bool bookMatch = userParts.book.toLowerCase() == expectedParts.book.toLowerCase();
    bool chapterMatch = userParts.chapter == expectedParts.chapter;
    bool verseMatch = userParts.verse == expectedParts.verse;

    if (bookMatch && chapterMatch && !verseMatch) {
      return "$userAnswer-[$expectedRef] Correct book and chapter";
    } else if (bookMatch && !chapterMatch) {
      return "$userAnswer-[$expectedRef] Correct book";
    } else {
      return "$userAnswer-[$expectedRef] Incorrect";
    }
  }

  void submitAnswer() {
    if (isValidVerseRef(answerController.text)) {
      setState(() {
        hasSubmittedAnswer = true;

        // Parse references for exact comparison
        final expectedParts = _parseReference(expectedReference);
        final userParts = _parseReference(answerController.text);

        if (expectedParts != null && userParts != null) {
          // Check for exact match
          isAnswerCorrect = userParts.book.toLowerCase() == expectedParts.book.toLowerCase() &&
              userParts.chapter == expectedParts.chapter &&
              userParts.verse == expectedParts.verse;
        } else {
          // Fall back to string comparison if parsing fails
          isAnswerCorrect = answerController.text.trim().toLowerCase() == expectedReference.toLowerCase();
        }

        if (isAnswerCorrect) {
          referenceRecallGrade = (referenceRecallGrade + 100) / 2;
          if (referenceRecallGrade > 100) referenceRecallGrade = 100;

          // Decrease overdue references count when answer is correct
          if (overdueReferences > 0) {
            overdueReferences--;
          }
        }

        // Add the feedback summary to past questions
        pastQuestions.add(_generateFeedbackSummary(answerController.text, expectedReference));
        // Keep only the last 5 questions
        if (pastQuestions.length > 5) {
          pastQuestions = pastQuestions.sublist(pastQuestions.length - 5);
        }
      });

      // Show feedback in a snackbar
      final String detailedFeedback = isAnswerCorrect
          ? 'Great job! You correctly identified this verse as $expectedReference.'
          : getDetailedFeedback(answerController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(detailedFeedback),
          backgroundColor: isAnswerCorrect ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );

      // Automatically move to next verse after a short delay
      // regardless of whether the answer was correct
      Future.delayed(const Duration(milliseconds: 1500), () {
        _loadNextVerse();
      });

      debugPrint('Answer submitted: ${answerController.text}, Correct: $isAnswerCorrect');
    } else {
      debugPrint('Invalid reference: ${answerController.text}');
    }
  }

  InputDecoration getInputDecoration() {
    final bool showSuccessStyle = hasSubmittedAnswer && isAnswerCorrect;
    final bool showErrorStyle = hasSubmittedAnswer && !isAnswerCorrect;

    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle ? Colors.green :
          showErrorStyle ? Colors.orange :
          Colors.grey[300]!,
          width: (showSuccessStyle || showErrorStyle) ? 2.0 : 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle ? Colors.green :
          showErrorStyle ? Colors.orange :
          Colors.grey[300]!,
          width: (showSuccessStyle || showErrorStyle) ? 2.0 : 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: showSuccessStyle ? Colors.green :
          showErrorStyle ? Colors.orange :
          Colors.blue,
          width: 2.0,
        ),
      ),
      hintText: 'Enter reference (e.g., Genesis 1:1)',
      errorText: isReferenceValid ? null : validationMessage,
      helperText: showSuccessStyle ? 'Correct!' :
      showErrorStyle ? getDetailedFeedback(answerController.text) :
      'Format: Book Chapter:Verse',
      helperStyle: TextStyle(
        color: showSuccessStyle ? Colors.green :
        showErrorStyle ? Colors.orange :
        Colors.grey[600],
        fontWeight: (showSuccessStyle || showErrorStyle) ? FontWeight.bold : FontWeight.normal,
      ),
      suffixIcon: showSuccessStyle
          ? const Icon(Icons.check_circle, color: Colors.green)
          : showErrorStyle
          ? const Icon(Icons.cancel, color: Colors.orange)
          : null,
      filled: showSuccessStyle || showErrorStyle,
      fillColor: showSuccessStyle ? Colors.green.withOpacity(0.1) :
      showErrorStyle ? Colors.orange.withOpacity(0.1) :
      null,
    );
  }

  void _setRandomVerse() {
    setState(() {
      currentVerseIndex = DateTime.now().millisecondsSinceEpoch % versesList.length;
      verseText = versesList[currentVerseIndex]["text"]!;
      expectedReference = versesList[currentVerseIndex]["reference"]!;
    });
  }

  // Function to load next verse
  void _loadNextVerse() {
    setState(() {
      // Reset the answer field and submission state
      answerController.clear();
      hasSubmittedAnswer = false;
      isAnswerCorrect = false;

      // Increment question number
      questionNumber++;

      // Move to next verse (cyclically)
      currentVerseIndex = (currentVerseIndex + 1) % versesList.length;
      verseText = versesList[currentVerseIndex]["text"]!;
      expectedReference = versesList[currentVerseIndex]["reference"]!;
    });
  }

  @override
  void initState() {
    super.initState();
    answerFocusNode.requestFocus();

    // Set the initial verse
    _setRandomVerse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          margin: const EdgeInsets.all(16.0),
          child: isSmallScreen
              ? Column(
            children: [
              _buildQuestionSection(),
              const SizedBox(height: 24.0),
              _buildStatsAndHistorySection(),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: _buildQuestionSection()),
              const SizedBox(width: 16.0),
              Expanded(child: _buildStatsAndHistorySection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Question: '),
                TextSpan(
                  text: '$questionNumber',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        // Verse text with NLT attribution - explicitly above the reference field
        Container(
          key: const Key('reftestVerse'),
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 24.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey[50],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                verseText,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    verseAttribution,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Reference label
        Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: const Text(
            'Reference:',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),

        // Simple text field with autocomplete options displayed below
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: answerController,
              focusNode: answerFocusNode,
              decoration: getInputDecoration(),
              onChanged: (value) {
                // Reset submission state when typing
                if (hasSubmittedAnswer) {
                  setState(() {
                    hasSubmittedAnswer = false;
                    isAnswerCorrect = false;
                  });
                }

                // Show autocomplete suggestions if we're typing a book name
                setState(() {});
              },
              onSubmitted: (value) {
                submitAnswer();
              },
            ),

            // Show book suggestions if relevant
            if (_shouldShowSuggestions())
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: _getFilteredSuggestions().map((book) {
                    return ListTile(
                      dense: true,
                      title: Text(book),
                      onTap: () {
                        _selectBookSuggestion(book);
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        ),

        const SizedBox(height: 16.0),

        // Submit button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            key: const Key('submit-ref'),
            onPressed: submitAnswer,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ),

        // Success/failure message (only shown after submission)
        if (hasSubmittedAnswer)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isAnswerCorrect ? Icons.thumb_up : Icons.error_outline,
                      color: isAnswerCorrect ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isAnswerCorrect
                            ? 'Great job! You correctly identified this verse as $expectedReference.'
                            : getDetailedFeedback(answerController.text),
                        style: TextStyle(
                          color: isAnswerCorrect ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _shouldShowSuggestions() {
    // Show suggestions if text is not empty and doesn't contain a space yet
    final text = answerController.text.trim();
    return text.isNotEmpty && !text.contains(' ') && _getFilteredSuggestions().isNotEmpty;
  }

  List<String> _getFilteredSuggestions() {
    final text = answerController.text.trim().toLowerCase();
    if (text.isEmpty) return [];

    // Filter books that start with the current text
    return bookSuggestions
        .where((book) => book.toLowerCase().startsWith(text))
        .take(5) // Limit to 5 suggestions
        .toList();
  }

  void _selectBookSuggestion(String book) {
    setState(() {
      // Add a space after the book name to prepare for entering chapter:verse
      answerController.text = '$book ';

      // Position cursor at the end
      answerController.selection = TextSelection.fromPosition(
        TextPosition(offset: answerController.text.length),
      );

      // Reset submission state if needed
      if (hasSubmittedAnswer) {
        hasSubmittedAnswer = false;
        isAnswerCorrect = false;
      }
    });

    // Ensure focus returns to the text field
    answerFocusNode.requestFocus();
  }

  Widget _buildStatsAndHistorySection() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 160,
                child: _buildGauge(),
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey[100],
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      '$overdueReferences',
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'References Due Today',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Prior Questions',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Container(
                key: const Key('past-questions'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pastQuestions.isEmpty
                      ? [const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('No previous questions yet'),
                  )]
                      : pastQuestions.map((feedback) {
                    // Determine if this was a correct answer
                    final bool wasCorrect = feedback.contains(' Correct!');

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        feedback,
                        style: TextStyle(
                          color: wasCorrect ? Colors.green : Colors.orange,
                          fontWeight: pastQuestions.indexOf(feedback) == pastQuestions.length - 1
                              ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
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
      children: [
        const Text('Reference Recall', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: referenceRecallGrade / 100,
                strokeWidth: 15,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
              ),
            ),
            Text(
              '${referenceRecallGrade.toInt()}%',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
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



class ParsedReference {
  final String book;
  final int chapter;
  final int verse;

  ParsedReference(this.book, this.chapter, this.verse);

  @override
  String toString() {
    return '$book $chapter:$verse';
  }
}


/*
Below is Gherkin which clause provided from the prompt
Can you descrbe this in granular gherkin please such as when i type "Genesis 1:1" in the textfield i see ... text message
--
Feature: Bible Reference Testing Application

  Background:
    Given I have launched the Reference Testing app
    And I see a verse displayed on the screen
    And the verse reference is hidden
    And the "References Due Today" counter shows "5"
    And the Past Questions section shows "No previous questions yet"

  Scenario: Successfully identifying a verse reference
    When I type "Genesis 1:1" in the reference input field
    Then I see auto-suggestions for "Genesis" appear below the input
    When I select "Genesis" from the suggestions
    Then the input field is populated with "Genesis " with the cursor after the space
    When I continue typing "1:1"
    And I tap the "Submit" button
    Then I see a green checkmark icon in the input field
    And I see "Correct!" text below the input field
    And I see a green SnackBar message: "Great job! You correctly identified this verse as Genesis 1:1."
    And the "References Due Today" counter decreases to "4"
    And in the Past Questions section I see "Genesis 1:1-[Genesis 1:1] Correct!" in green bold text
    And after 1.5 seconds, a new verse is automatically displayed
    And the input field is cleared

  Scenario: Identifying a verse with correct book and chapter but wrong verse
    When I type "Philippians 4:12" in the reference input field
    And the actual reference is "Philippians 4:13"
    And I tap the "Submit" button
    Then I see an orange warning icon in the input field
    And I see an orange SnackBar message: "You got the book and chapter right, but the verse is incorrect. The correct reference is Philippians 4:13."
    And in the Past Questions section I see "Philippians 4:12-[Philippians 4:13] Correct book and chapter" in orange bold text
    And the "References Due Today" counter remains at "5"
    And after 1.5 seconds, a new verse is automatically displayed
    And the input field is cleared

  Scenario: Identifying a verse with correct book but wrong chapter and verse
    When I type "Romans 7:28" in the reference input field
    And the actual reference is "Romans 8:28"
    And I tap the "Submit" button
    Then I see an orange warning icon in the input field
    And I see an orange SnackBar message: "You got the book right, but the chapter is incorrect. The correct reference is Romans 8:28."
    And in the Past Questions section I see "Romans 7:28-[Romans 8:28] Correct book" in orange bold text
    And the "References Due Today" counter remains at "5"
    And after 1.5 seconds, a new verse is automatically displayed
    And the input field is cleared

  Scenario: Identifying a verse with completely incorrect reference
    When I type "Matthew 5:5" in the reference input field
    And the actual reference is "John 3:16"
    And I tap the "Submit" button
    Then I see an orange warning icon in the input field
    And I see an orange SnackBar message: "The book you entered is incorrect. The correct reference is John 3:16."
    And in the Past Questions section I see "Matthew 5:5-[John 3:16] Incorrect" in orange bold text
    And the "References Due Today" counter remains at "5"
    And after 1.5 seconds, a new verse is automatically displayed
    And the input field is cleared

  Scenario: Entering an invalid reference format
    When I type "Genesis" in the reference input field
    And I tap the "Submit" button
    Then I see a red error message: "Format should be 'Book Chapter:Verse'"
    And no SnackBar appears
    And no new entry is added to the Past Questions section
    And the "References Due Today" counter remains unchanged
    And the current verse remains displayed

  Scenario: Viewing reference recall progress
    Given I have correctly identified 3 verses
    When I look at the Reference Recall meter
    Then I see a circular progress indicator showing my success rate
    And the percentage displayed in the center reflects my average score
    And the gauge is colored according to my performance:
      | Performance Range | Color  |
      | Below 33%         | Red    |
      | 33% to 66%        | Orange |
      | Above 66%         | Green  |

  Scenario: Tracking previous answers
    Given I have answered 6 verse references
    When I look at the Past Questions section
    Then I see only the 5 most recent answers
    And each answer shows the format: "MyAnswer-[CorrectReference] FeedbackType"
    And correct answers are displayed in green text
    And incorrect answers are displayed in orange text
    And the most recent answer is displayed in bold text

 */