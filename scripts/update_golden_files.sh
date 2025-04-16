#!/bin/bash

# Color codes for terminal output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print in color
print_color() {
  echo -e "${2}${1}${NC}"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
  print_color "Error: Flutter is not installed or not in PATH." "${RED}"
  exit 1
fi

# Directory for storing golden test images
GOLDENS_DIR="test"

# Create goldens directory if it doesn't exist
mkdir -p "$GOLDENS_DIR"

print_color "Updating golden files..." "${YELLOW}"
flutter test --update-goldens --tags golden

# Check if the command succeeded
if [ $? -eq 0 ]; then
  print_color "✅ Golden files updated successfully!" "${GREEN}"
  
  # Count golden files
  GOLDEN_COUNT=$(find "$GOLDENS_DIR" -path "*/goldens/*.png" | wc -l | xargs)
  print_color "Found $GOLDEN_COUNT golden files." "${YELLOW}"
  
  # List locations where golden files exist
  print_color "Golden files were updated in:" "${YELLOW}"
  find "$GOLDENS_DIR" -path "*/goldens" -type d | sort | while read dir; do
    COUNT=$(find "$dir" -name "*.png" | wc -l | xargs)
    if [ "$COUNT" -gt "0" ]; then
      print_color " - $dir: $COUNT files" "${GREEN}"
    fi
  done
else
  print_color "❌ Failed to update golden files." "${RED}"
  exit 1
fi