#!/bin/bash
# Script for checking prohibited logging methods
# This can be used by both the check_before_commit.sh script and CI pipeline

# Define colors and print functions for local usage (will be ignored in CI)
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; NC='\033[0m'
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${YELLOW}➤ $1${NC}"; }

# Initialize variables
SCRIPT_MODE="${1:-local}"  # Default to local mode if not specified
EXIT_ON_FAILURE=1          # Default to exit on failure
AUTO_FIX="${2:-false}"     # Whether to attempt auto-fixes (only in local mode)
DIRECTORIES="lib test"     # Directories to scan

echo "Checking for prohibited logging methods..."

# Scan both lib/ and test/, match only standalone calls, and drop commented lines
GREP_RESULTS=$(
  grep -r --include="*.dart" -E '\b(debugPrint\(|log\()' $DIRECTORIES 2>/dev/null || true \
  | grep -v '^\s*//' || true
)

if [ -n "$GREP_RESULTS" ]; then
  if [ "$SCRIPT_MODE" == "ci" ]; then
    # CI mode - format for GitHub Actions
    echo "::error::Found prohibited logging methods. Please use AppLogger.d() or AppLogger.e() instead:"
    echo "$GREP_RESULTS"
  else
    # Local mode - more detailed output
    print_error "Found prohibited logging methods."
    echo "Offending lines:"
    echo "$GREP_RESULTS" | awk -F ':' '{print "  " $1 ":" $2 ": " $3}'
    
    # Auto-fix if requested
    if [ "$AUTO_FIX" == "true" ]; then
      print_info "Attempting automatic fixes..."
      
      # Loop through each found violation and attempt to fix it
      echo "$GREP_RESULTS" | while IFS= read -r line; do
        FILE_PATH=$(echo "$line" | cut -d ':' -f 1)
        LINE_NUM=$(echo "$line" | cut -d ':' -f 2)
        LINE_CONTENT=$(echo "$line" | cut -d ':' -f 3-)

        # Attempt to replace debugPrint or log with AppLogger.d
        # Using sed -i '' for macOS compatibility
        if [[ "$LINE_CONTENT" == *"debugPrint("* ]]; then
          sed -i.bak "s/debugPrint(/AppLogger.d(/g" "$FILE_PATH"
          FIX_TYPE="debugPrint -> AppLogger.d"
        elif [[ "$LINE_CONTENT" =~ \blog\( ]]; then # Use regex match for word boundary
          sed -i.bak "s/\blog(/AppLogger.d(/g" "$FILE_PATH"
          FIX_TYPE="log -> AppLogger.d"
        else
          continue # Should not happen based on grep, but good practice
        fi

        # Remove backup file created by sed
        rm -f "${FILE_PATH}.bak"
        
        print_info "Fixed $FIX_TYPE in $FILE_PATH:$LINE_NUM"

        # Check if AppLogger import is present, add if not
        if ! grep -q "package:memverse/src/utils/app_logger.dart" "$FILE_PATH"; then
          # Add import at the beginning of the file
          IMPORT_LINE="import 'package:memverse/src/utils/app_logger.dart';"
          # Use printf for safer handling of the import string with sed
          printf '%s\n' "1i" "$IMPORT_LINE" "." "w" | ed -s "$FILE_PATH"
          print_info "Added AppLogger import to $FILE_PATH"
        fi
      done

      print_error "Automatic fixes applied. Please review the changes carefully."
    fi
  fi
  
  exit $EXIT_ON_FAILURE
else
  if [ "$SCRIPT_MODE" == "ci" ]; then
    echo "No prohibited logging methods found. All code uses AppLogger as required."
  else
    print_success "No prohibited logging methods found"
  fi
  exit 0
fi