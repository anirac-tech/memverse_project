import 'package:flutter/material.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

class VerseCard extends StatelessWidget {
  // This card is used by the reference-quiz feature. The reference is intentionally
  // hidden here because users are expected to type the reference for the quiz.
  const VerseCard({required this.verse, super.key});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    const colorGreen = Color(0xFF80BC00);
    const colorLightGreen = Color(0xFFC8F780);
    return Container(
      key: const Key('refTestVerse'),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: colorLightGreen.withOpacity(.24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorGreen.withOpacity(.19)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 9,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reference intentionally omitted in reference-quiz flow.
          const SizedBox(height: 4),
          // Show the full verse text and allow the parent to size the card so the
          // verse is not clipped. The parent `QuestionSection` controls maxHeight.
          Text(
            verse.text,
            style: const TextStyle(
              fontSize: 16.8,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: colorGreen.withOpacity(.10),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  verse.translation,
                  style: const TextStyle(
                    fontSize: 12.6,
                    color: colorGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
