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

# Directory for AI prompts logs
LOGS_DIR="ai_prompts_logs"
mkdir -p "$LOGS_DIR"

# Get current branch name
BRANCH_NAME=$(git branch --show-current)
if [ -z "$BRANCH_NAME" ]; then
  print_color "Error: Not in a git branch" "$RED"
  exit 1
fi

# Extract prefix (MEM-XX)
BRANCH_PREFIX=$(echo "$BRANCH_NAME" | grep -o 'MEM-[0-9]*')
if [ -z "$BRANCH_PREFIX" ]; then
  print_color "Warning: Branch name does not follow MEM-XX pattern. Using branch name as is." "$YELLOW"
  BRANCH_PREFIX="$BRANCH_NAME"
fi

# Log file name based on branch prefix
LOG_FILE="$LOGS_DIR/${BRANCH_PREFIX}_ai_prompts.log"

# Get current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %I:%M:%S %p')

# Ask for the prompt
print_color "Enter the AI prompt (type 'EOF' on a line by itself to finish):" "$YELLOW"
prompt=""
while IFS= read -r line; do
  [ "$line" = "EOF" ] && break
  prompt="$prompt$line
"
done

# Append the prompt to the log file
echo -e "\n====================\n$TIMESTAMP\n====================\n$prompt" >> "$LOG_FILE"

print_color "✅ Prompt added to $LOG_FILE" "$GREEN"