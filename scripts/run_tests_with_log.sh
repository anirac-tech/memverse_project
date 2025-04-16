#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Run specific tests or all tests and log the output
if [ "$1" == "" ]; then
  # Run all tests
  echo "Running all tests..."
  flutter test > logs/test_output_$(date +%Y%m%d_%H%M%S).log 2>&1
else
  # Run specific test
  echo "Running test: $1"
  flutter test --name="$1" > logs/test_output_$1_$(date +%Y%m%d_%H%M%S).log 2>&1
fi

# Output the last few lines of the log to console
echo "Test complete. Log saved to logs/test_output*.log"
echo "Last 50 lines of log:"
tail -n 50 logs/test_output_*.log | sort | tail -n 50