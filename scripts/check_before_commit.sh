#!/bin/bash

set -e

echo "==== CHECKING FOR PROHIBITED LOGGING METHODS ===="
! grep -r --include="*.dart" "print(" lib || (echo "❌ Found prohibited logging method 'print'. Use AppLogger instead." && exit 1)
echo "✓ No prohibited logging methods found"
echo

echo "==== CHECKING DEPENDENCIES ===="
command -v flutter >/dev/null 2>&1 || { echo "❌ Flutter not found. Please install Flutter."; exit 1; }
echo "✓ All dependencies found"
echo "➤ Flutter version:"
flutter --version
echo

echo "==== APPLYING DARTFIX ===="
echo "➤ Running dart fix..."
dart fix --apply
echo "✓ Applied dart fixes"
echo

echo "==== FORMATTING CODE ===="
echo "➤ Running dart format..."
dart format --line-length=100 .
echo "✓ Code formatted"
echo

echo "==== ANALYZING CODE ===="
echo "➤ Running flutter analyze..."
flutter analyze
if [ $? -ne 0 ]; then
  echo "❌ Analysis failed. Please fix the issues before committing."
  exit 1
fi
echo "✓ Analysis passed"

# Make script executable
chmod +x $0