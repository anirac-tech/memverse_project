#!/bin/bash
set -e

# Colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing trailing commas in generated localization files...${NC}"

# Path to the app_localizations.dart file
LOCALIZATIONS_FILE="lib/l10n/arb/app_localizations.dart"

# Check if the file exists
if [ ! -f "$LOCALIZATIONS_FILE" ]; then
  echo -e "${RED}Error: $LOCALIZATIONS_FILE not found.${NC}"
  exit 1
fi

# Use sed to add trailing comma after the last locale in the supportedLocales list
# This handles both single-line and multi-line formats
if grep -q "supportedLocales.*\[.*Locale('.*').*\]" "$LOCALIZATIONS_FILE"; then
  # For single-line format: replace the last ) before the closing ] with ),
  sed -i.bak 's/\(Locale(.*)\)\(\s*\]\)/\1,\2/g' "$LOCALIZATIONS_FILE"
else
  # For multi-line format: find the last Locale line before the closing ] and add a comma
  sed -i.bak '/Locale(.*)/!b;/.*\].*/!{:a;N;/.*\].*/!ba};s/\(Locale([^,]*)\)\(\s*\]\)/\1,\2/g' "$LOCALIZATIONS_FILE"
fi

# Remove backup file
rm -f "${LOCALIZATIONS_FILE}.bak"

# Check if the fix was applied
if grep -q "Locale('.*')," "$LOCALIZATIONS_FILE"; then
  echo -e "${GREEN}Successfully fixed trailing commas in $LOCALIZATIONS_FILE${NC}"
else
  echo -e "${YELLOW}No changes needed or couldn't apply fix automatically.${NC}"
fi

echo -e "${YELLOW}Running dart format to ensure consistent formatting...${NC}"
dart format "$LOCALIZATIONS_FILE"

echo -e "${GREEN}Done!${NC}"