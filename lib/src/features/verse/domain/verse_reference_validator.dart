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

  /// Map of common Bible book abbreviations to their full names
  static final Map<String, String> bookAbbreviations = {
    // Old Testament abbreviations
    'gen': 'Genesis',
    'exo': 'Exodus',
    'lev': 'Leviticus',
    'num': 'Numbers',
    'deut': 'Deuteronomy',
    'josh': 'Joshua',
    'judg': 'Judges',
    '1 sam': '1 Samuel',
    '2 sam': '2 Samuel',
    '1 kgs': '1 Kings',
    '2 kgs': '2 Kings',
    '1 chr': '1 Chronicles',
    '2 chr': '2 Chronicles',
    'neh': 'Nehemiah',
    'est': 'Esther',
    'ps': 'Psalm',
    'psa': 'Psalm',
    'prov': 'Proverbs',
    'eccl': 'Ecclesiastes',
    'song': 'Song of Songs',
    'isa': 'Isaiah',
    'jer': 'Jeremiah',
    'lam': 'Lamentations',
    'ezek': 'Ezekiel',
    'dan': 'Daniel',
    'hos': 'Hosea',
    'zech': 'Zechariah',
    'mal': 'Malachi',

    // New Testament abbreviations
    'matt': 'Matthew',
    'mk': 'Mark',
    'lk': 'Luke',
    'jn': 'John',
    'rom': 'Romans',
    '1 cor': '1 Corinthians',
    '2 cor': '2 Corinthians',
    'gal': 'Galatians',
    'eph': 'Ephesians',
    'phil': 'Philippians',
    'col': 'Colossians',
    '1 thess': '1 Thessalonians',
    '2 thess': '2 Thessalonians',
    '1 tim': '1 Timothy',
    '2 tim': '2 Timothy',
    'tit': 'Titus',
    'phlm': 'Philemon',
    'heb': 'Hebrews',
    'jas': 'James',
    '1 pet': '1 Peter',
    '2 pet': '2 Peter',
    '1 jn': '1 John',
    '2 jn': '2 John',
    '3 jn': '3 John',
    'rev': 'Revelation',
  };

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
      final lowerBookName = bookName.toLowerCase();

      // Check if it's a full book name
      if (bookSuggestions.any((book) => book.toLowerCase() == lowerBookName)) {
        return true;
      }

      // Check if it's an abbreviation
      final fullBookName = bookAbbreviations[lowerBookName];
      return fullBookName != null;
    }
    return false;
  }

  /// Get the standardized book name from an input that may be a full name or abbreviation
  static String getStandardBookName(String inputBookName) {
    final lowerInput = inputBookName.toLowerCase();
    
    // Check if it's already a full book name
    for (final book in bookSuggestions) {
      if (book.toLowerCase() == lowerInput) {
        return book; // Return the properly cased book name
      }
    }
    
    // Check if it's an abbreviation
    return bookAbbreviations[lowerInput] ?? inputBookName;
  }
}