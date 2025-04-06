import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';

void main() {
  group('Abbreviations Functionality Test', () {
    test('Standard book names and abbreviations are correctly handled', () {
      // Confirm our abbreviations are recognized
      expect(VerseReferenceValidator.isValid('Col 1:17'), isTrue);
      expect(VerseReferenceValidator.isValid('Phil 4:13'), isTrue);
      
      // Confirm standard names work as well
      expect(VerseReferenceValidator.isValid('Colossians 1:17'), isTrue);
      expect(VerseReferenceValidator.isValid('Philippians 4:13'), isTrue);
      
      // Test getStandardBookName
      expect(VerseReferenceValidator.getStandardBookName('Col'), equals('Colossians'));
      expect(VerseReferenceValidator.getStandardBookName('Phil'), equals('Philippians'));
      expect(VerseReferenceValidator.getStandardBookName('col'), equals('Colossians'));
      expect(VerseReferenceValidator.getStandardBookName('PHIL'), equals('Philippians'));
      
      // Test standard names are preserved
      expect(VerseReferenceValidator.getStandardBookName('Colossians'), equals('Colossians'));
      expect(VerseReferenceValidator.getStandardBookName('Philippians'), equals('Philippians'));
      
      // Test converting the full reference
      final colRef = 'Col 1:17';
      final colMatch = RegExp(r'^(([1-3]\s+)?[A-Za-z]+(\s+[A-Za-z]+)*)\s+(\d+):(\d+)(-\d+)?$').firstMatch(colRef);
      final colBookName = colMatch?.group(1)?.trim() ?? '';
      expect(VerseReferenceValidator.getStandardBookName(colBookName), equals('Colossians'));
      
      final philRef = 'Phil 4:13';
      final philMatch = RegExp(r'^(([1-3]\s+)?[A-Za-z]+(\s+[A-Za-z]+)*)\s+(\d+):(\d+)(-\d+)?$').firstMatch(philRef);
      final philBookName = philMatch?.group(1)?.trim() ?? '';
      expect(VerseReferenceValidator.getStandardBookName(philBookName), equals('Philippians'));
    });
  });
}