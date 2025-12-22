import 'package:flutter/material.dart';

class QuizRatingWidget extends StatelessWidget {
  const QuizRatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const colorGreen = Color(0xFF80BC00);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: CircleAvatar(
            backgroundColor: i == 2 ? colorGreen.withOpacity(0.15) : Colors.white,
            radius: 22,
            child: i < 5
                ? Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: i == 2 ? FontWeight.bold : FontWeight.normal,
                      color: i == 2 ? colorGreen : Colors.grey.shade600,
                    ),
                  )
                : const Icon(Icons.info_outline, color: colorGreen, size: 22),
          ),
        ),
      ),
    );
  }
}
