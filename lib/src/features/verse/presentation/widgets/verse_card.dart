import 'package:flutter/material.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

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
