import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/main.dart' as app;
import 'package:memverse/src/features/verse/domain/verse_reference_validator.dart';

// This test verifies that abbreviations work in the verse reference validator
void main() {
  group('Verse Reference Validator Abbreviations', () {
    test('Abbreviations are properly set up', () {
      // Test most important abbreviations needed for the current app
      expect(VerseReferenceValidator.isValid('Col 1:17'), isTrue);
      expect(VerseReferenceValidator.isValid('Phil 4:13'), isTrue);
      expect(VerseReferenceValidator.getStandardBookName('Col'), equals('Colossians'));
      expect(VerseReferenceValidator.getStandardBookName('Phil'), equals('Philippians'));
    });
    
    test('Validator handles case variations', () {
      expect(VerseReferenceValidator.isValid('col 1:17'), isTrue);
      expect(VerseReferenceValidator.isValid('PHIL 4:13'), isTrue);
      expect(VerseReferenceValidator.getStandardBookName('col'), equals('Colossians'));
      expect(VerseReferenceValidator.getStandardBookName('PHIL'), equals('Philippians'));
    });
    
    test('Standard book names are preserved', () {
      expect(VerseReferenceValidator.isValid('Colossians 1:17'), isTrue);
      expect(VerseReferenceValidator.isValid('Philippians 4:13'), isTrue);
      expect(VerseReferenceValidator.getStandardBookName('Colossians'), equals('Colossians'));
      expect(VerseReferenceValidator.getStandardBookName('Philippians'), equals('Philippians'));
    });
  });
}