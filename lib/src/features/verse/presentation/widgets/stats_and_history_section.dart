import 'package:flutter/material.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/presentation/widgets/question_history_widget.dart';
import 'package:memverse/src/features/verse/presentation/widgets/reference_gauge.dart';

class StatsAndHistorySection extends StatelessWidget {
  const StatsAndHistorySection({
    required this.progress,
    required this.totalCorrect,
    required this.totalAnswered,
    required this.l10n,
    required this.overdueReferences,
    required this.pastQuestions,
    this.isLoading = false,
    this.hasError = false,
    this.isValidated = false,
    this.error,
    this.validationError,
    super.key,
  });

  final double progress;
  final int totalCorrect;
  final int totalAnswered;
  final AppLocalizations l10n;
  final bool isLoading;
  final bool hasError;
  final bool isValidated;
  final int overdueReferences;
  final List<String> pastQuestions;
  final String? error;
  final String? validationError;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 160,
              child: Center(
                child: ReferenceGauge(
                  progress: progress,
                  totalCorrect: totalCorrect,
                  totalAnswered: totalAnswered,
                  l10n: l10n,
                  isLoading: isLoading,
                  error: error,
                  validationError: validationError,
                ),
              ),
            ),
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
                    l10n.referencesDueToday,
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
      QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: l10n),
    ],
  );
}