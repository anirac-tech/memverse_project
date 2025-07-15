import 'package:flutter/material.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/ref_quiz/widgets/question_history_widget.dart';

class StatsAndHistorySection extends StatelessWidget {
  const StatsAndHistorySection({required this.l10n, required this.pastQuestions, super.key});

  final AppLocalizations l10n;
  final List<String> pastQuestions;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[QuestionHistoryWidget(pastQuestions: pastQuestions, l10n: l10n)],
  );
}
