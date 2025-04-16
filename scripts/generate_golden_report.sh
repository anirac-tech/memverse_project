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

# Directory to store the report
REPORT_DIR="golden_report"
mkdir -p "$REPORT_DIR"

# Run golden tests (don't fail on differences)
print_color "Running golden tests..." "$YELLOW"
flutter test --tags golden || true

# Check if there are any failure images
FAILURE_IMAGES=$(find test -path "*/failures/*.png")
if [ -z "$FAILURE_IMAGES" ]; then
  print_color "✅ No differences detected in golden tests!" "$GREEN"
else
  print_color "⚠️ Differences detected in golden tests. Generating report..." "$YELLOW"
fi

# Create HTML report
HTML_FILE="$REPORT_DIR/index.html"

# Start HTML file
cat > "$HTML_FILE" << EOL
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Golden Test Report</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      color: #333;
    }
    h1, h2 {
      color: #1976d2;
    }
    .comparison {
      display: flex;
      margin-bottom: 30px;
      border: 1px solid #ddd;
      padding: 15px;
      border-radius: 5px;
    }
    .comparison-item {
      margin: 10px;
      text-align: center;
    }
    img {
      max-width: 360px;
      border: 1px solid #ccc;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .no-diff {
      background-color: #e8f5e9;
      padding: 20px;
      border-radius: 5px;
      text-align: center;
      color: #2e7d32;
    }
    .has-diff {
      background-color: #ffebee;
      padding: 20px;
      border-radius: 5px;
      text-align: center;
      color: #c62828;
    }
  </style>
</head>
<body>
  <h1>Golden Test Report</h1>
  <p>Generated on $(date)</p>
EOL

# If no failures, just show a success message
if [ -z "$FAILURE_IMAGES" ]; then
  cat >> "$HTML_FILE" << EOL
  <div class="no-diff">
    <h2>✅ All golden tests passed! No differences detected.</h2>
  </div>
EOL
else
  cat >> "$HTML_FILE" << EOL
  <div class="has-diff">
    <h2>⚠️ Golden test differences detected</h2>
    <p>Review the comparison below and update the golden files if the changes are intentional.</p>
  </div>
EOL

  # For each failure image, create a comparison with the golden file
  for failure in $FAILURE_IMAGES; do
    # Extract test name and find corresponding golden image
    failure_basename=$(basename "$failure")
    test_name=${failure_basename#*_}
    test_dir=$(dirname "$(dirname "$failure")")
    golden_image="$test_dir/goldens/$test_name"
    
    if [ -f "$golden_image" ]; then
      # Add comparison to HTML
      cat >> "$HTML_FILE" << EOL
  <div class="comparison">
    <div class="comparison-item">
      <h3>Expected (Golden)</h3>
      <img src="../$golden_image" alt="Golden Image">
      <p>$golden_image</p>
    </div>
    <div class="comparison-item">
      <h3>Actual (Failure)</h3>
      <img src="../$failure" alt="Failure Image">
      <p>$failure</p>
    </div>
  </div>
EOL
    else
      # Golden file not found (might be a new test without an existing golden)
      cat >> "$HTML_FILE" << EOL
  <div class="comparison">
    <div class="comparison-item">
      <h3>Expected (Golden)</h3>
      <p>No golden image found for $test_name</p>
    </div>
    <div class="comparison-item">
      <h3>Actual (Failure)</h3>
      <img src="../$failure" alt="Failure Image">
      <p>$failure</p>
    </div>
  </div>
EOL
    fi
  done
fi

# Close HTML
cat >> "$HTML_FILE" << EOL
</body>
</html>
EOL

print_color "Report generated at $HTML_FILE" "$GREEN"
print_color "To view the report, open it in your browser: open $HTML_FILE" "$YELLOW"