import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeeCorrectFeedbackWithGreenStyling(WidgetTester tester) async {
  // Check for green styling elements
  final greenIcon = find.byIcon(Icons.check_circle);
  expect(greenIcon, findsOneWidget);

  // Verify the icon is green
  final iconWidget = tester.widget<Icon>(greenIcon);
  expect(iconWidget.color, Colors.green);

  // Look for green border on the text field
  final textField = find.byType(TextField).last;
  expect(textField, findsOneWidget);

  final textFieldWidget = tester.widget<TextField>(textField);
  final decoration = textFieldWidget.decoration!;

  // Check if border is green
  expect(decoration.enabledBorder?.borderSide.color, Colors.green);
}

Future<void> iShouldSeeAlmostCorrectFeedbackWithOrangeStyling(WidgetTester tester) async {
  // Check for orange styling elements
  final orangeIcon = find.byIcon(Icons.cancel);
  expect(orangeIcon, findsOneWidget);

  // Verify the icon is orange
  final iconWidget = tester.widget<Icon>(orangeIcon);
  expect(iconWidget.color, Colors.orange);

  // Look for orange border on the text field
  final textField = find.byType(TextField).last;
  expect(textField, findsOneWidget);

  final textFieldWidget = tester.widget<TextField>(textField);
  final decoration = textFieldWidget.decoration!;

  // Check if border is orange
  expect(decoration.enabledBorder?.borderSide.color, Colors.orange);
}

Future<void> iShouldSeeAGreenCheckIcon(WidgetTester tester) async {
  final greenIcon = find.byIcon(Icons.check_circle);
  expect(greenIcon, findsOneWidget);

  final iconWidget = tester.widget<Icon>(greenIcon);
  expect(iconWidget.color, Colors.green);
}

Future<void> iShouldSeeAnOrangeCancelIcon(WidgetTester tester) async {
  final orangeIcon = find.byIcon(Icons.cancel);
  expect(orangeIcon, findsOneWidget);

  final iconWidget = tester.widget<Icon>(orangeIcon);
  expect(iconWidget.color, Colors.orange);
}

Future<void> theInputFieldShouldHaveAGreenBorder(WidgetTester tester) async {
  final textField = find.byType(TextField).last;
  expect(textField, findsOneWidget);

  final textFieldWidget = tester.widget<TextField>(textField);
  final decoration = textFieldWidget.decoration!;

  expect(decoration.enabledBorder?.borderSide.color, Colors.green);
}

Future<void> theInputFieldShouldHaveAnOrangeBorder(WidgetTester tester) async {
  final textField = find.byType(TextField).last;
  expect(textField, findsOneWidget);

  final textFieldWidget = tester.widget<TextField>(textField);
  final decoration = textFieldWidget.decoration!;

  expect(decoration.enabledBorder?.borderSide.color, Colors.orange);
}

Future<void> iShouldSeeNotQuiteRightMessageWithCorrectReference(WidgetTester tester) async {
  // Look for the "Not quite right" message
  expect(find.textContaining('Not quite right'), findsOneWidget);

  // Look for the correct reference in the feedback
  expect(find.textContaining('Galatians 5:1'), findsOneWidget);
}

Future<void> iShouldSeeTheCorrectReferenceInTheFeedback(
  WidgetTester tester,
  String reference,
) async {
  expect(find.textContaining(reference), findsOneWidget);
}

Future<void> iShouldNotSeeAnyLoginErrors(WidgetTester tester) async {
  // Check that no error messages are visible
  expect(find.byType(SnackBar), findsNothing);
  expect(find.textContaining('Invalid'), findsNothing);
  expect(find.textContaining('Error'), findsNothing);
  expect(find.textContaining('Failed'), findsNothing);
}
