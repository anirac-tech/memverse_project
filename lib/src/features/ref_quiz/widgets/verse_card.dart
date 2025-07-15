import 'package:flutter/material.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

class VerseCard extends StatelessWidget {
  const VerseCard({required this.verse, super.key});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final colorGreen = const Color(0xFF80BC00);
    final colorLightGreen = const Color(0xFFC8F780);
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
          Text(
            verse.reference,
            style: TextStyle(color: colorGreen, fontWeight: FontWeight.bold, fontSize: 17.2),
          ),
          const SizedBox(height: 4),
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
                  verse.translation ?? 'NIV',
                  style: TextStyle(fontSize: 12.6, color: colorGreen, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
