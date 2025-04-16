#!/bin/bash

# Extract the Flutter version from pubspec.yaml
FLUTTER_VERSION=$(grep "flutter:" pubspec.yaml | head -1 | cut -d ':' -f 2 | tr -d ' ')

echo "$FLUTTER_VERSION"