class VerseReferenceValidator {
  static bool isValid(String ref) {
    return RegExp(r'^[1-3]?\s?[A-Za-z]+\s\d+:\d+$').hasMatch(ref.trim());
  }

  static String getStandardBookName(String book) {
    // Simplified; real would map various forms
    return book.trim().toLowerCase();
  }
}
