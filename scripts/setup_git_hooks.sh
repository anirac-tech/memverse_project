#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print in color
print_color() {
  echo -e "${2}${1}${NC}"
}

# Path to the Git hook directory
HOOK_DIR=.git/hooks

# Path to our pre-commit hook script
PRE_COMMIT_SCRIPT="scripts/check_before_commit.sh"

# Make sure the hook directory exists
mkdir -p "$HOOK_DIR"

# Check if check_before_commit.sh exists
if [ ! -f "$PRE_COMMIT_SCRIPT" ]; then
  print_color "Error: $PRE_COMMIT_SCRIPT not found. Make sure you're in the root project directory." "$RED"
  exit 1
fi

# Make the script executable
chmod +x "$PRE_COMMIT_SCRIPT"

# Create the pre-commit hook
cat > "$HOOK_DIR/pre-commit" << EOL
#!/bin/bash
# This hook was automatically installed by setup_git_hooks.sh

# Run the pre-commit checks
./scripts/check_before_commit.sh

# Exit with the same status as the script
exit \$?
EOL

# Make the hook executable
chmod +x "$HOOK_DIR/pre-commit"

print_color "✅ Git pre-commit hook installed successfully!" "$GREEN"
print_color "The script $PRE_COMMIT_SCRIPT will run before each commit." "$YELLOW"