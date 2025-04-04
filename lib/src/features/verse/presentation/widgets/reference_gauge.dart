import 'package:flutter/material.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';

class ReferenceGauge extends StatelessWidget {
  const ReferenceGauge({
    required this.progress,
    required this.totalCorrect,
    required this.totalAnswered,
    required this.l10n,
    this.isLoading = false,
    this.error,
    this.validationError,
    super.key,
  });

  final double progress;
  final int totalCorrect;
  final int totalAnswered;
  final AppLocalizations l10n;
  final bool isLoading;
  final String? error;
  final String? validationError;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    Color gaugeColor;
    if (progress < 33) {
      gaugeColor = Colors.red[400]!;
    } else if (progress < 66) {
      gaugeColor = Colors.orange[400]!;
    } else {
      gaugeColor = Colors.green[400]!;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Reference Progress', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 10),
        SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress / 100,
                strokeWidth: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${progress.round()}%',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text('$totalCorrect/$totalAnswered', style: const TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
