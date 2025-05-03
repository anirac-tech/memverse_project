#!/usr/bin/env python3
"""
Test suite for check_logging_standards.py

This file serves as both test coverage and documentation for how the logging standards checker works.
"""

import os
import tempfile
import unittest
from typing import List, Dict, Any
from pathlib import Path
from check_logging_standards import LoggingChecker, Mode, LoggingViolation


class TestLoggingChecker(unittest.TestCase):
    """Test cases for the LoggingChecker class."""

    def setUp(self):
        """Set up test cases."""
        # Create a temporary directory for our test files
        self.temp_dir = tempfile.TemporaryDirectory()
        self.test_dir = Path(self.temp_dir.name)
        
        # Create test files with various logging patterns
        self.create_test_files()

    def tearDown(self):
        """Clean up after tests."""
        self.temp_dir.cleanup()

    def create_test_files(self):
        """Create test Dart files with various logging patterns."""
        # Valid file with no violations
        valid_file = self.test_dir / "valid.dart"
        with open(valid_file, "w") as f:
            f.write("""
import 'package:memverse/src/utils/app_logger.dart';

void main() {
  AppLogger.d('This is a debug message');
  AppLogger.e('This is an error message', error, stackTrace);
}
""")

        # File with debugPrint violation
        debug_print_file = self.test_dir / "debug_print.dart"
        with open(debug_print_file, "w") as f:
            f.write("""
import 'package:flutter/foundation.dart';

void main() {
  // This is a method call
  debugPrint('This will be detected');
}
""")

        # File with log violation
        log_file = self.test_dir / "log.dart"
        with open(log_file, "w") as f:
            f.write("""
import 'dart:developer';

void main() {
  log('This will be detected');
  
  // This is a commented out log, should be ignored
  // log('This should be ignored');
}
""")

        # File with mixed violations
        mixed_file = self.test_dir / "mixed.dart"
        with open(mixed_file, "w") as f:
            f.write("""
import 'dart:developer';
import 'package:flutter/foundation.dart';

void main() {
  debugPrint('First violation');
  log('Second violation');
  
  // Inside comments, these should be ignored
  // debugPrint('Ignored');
  // log('Also ignored');
  
  // False positives that shouldn't be detected
  analogLog('Not a violation');
  myCustomDebugPrintHelper('Not a violation');
  
  // These should be detected even with indentation
  if (condition) {
    debugPrint('Indented violation');
    log('Another indented violation');
  }
}
""")

    def test_find_dart_files(self):
        """Test finding Dart files in directories."""
        checker = LoggingChecker([str(self.test_dir)])
        files = checker.find_dart_files()
        
        # Should find our 4 test files
        self.assertEqual(len(files), 4)
        
        # All files should have .dart extension
        for file in files:
            self.assertTrue(str(file).endswith('.dart'))

    def test_is_line_commented(self):
        """Test detection of commented lines."""
        checker = LoggingChecker([])
        
        # Test commented lines
        self.assertTrue(checker.is_line_commented("// This is a comment"))
        self.assertTrue(checker.is_line_commented("    // Indented comment"))
        
        # Test non-commented lines
        self.assertFalse(checker.is_line_commented("code(); // With comment"))
        self.assertFalse(checker.is_line_commented("  code();"))
        self.assertFalse(checker.is_line_commented(""))

    def test_find_violations(self):
        """Test finding logging violations."""
        checker = LoggingChecker([str(self.test_dir)])
        violations = checker.find_violations()
        
        # Should find 6 violations in our test files
        # 1 in debug_print.dart, 1 in log.dart, and 4 in mixed.dart
        self.assertEqual(len(violations), 6)
        
        # Check violation types
        debug_print_count = len([v for v in violations if v.violation_type == 'debugPrint'])
        log_count = len([v for v in violations if v.violation_type == 'log'])
        
        self.assertEqual(debug_print_count, 3)  # 1 in debug_print.dart, 2 in mixed.dart
        self.assertEqual(log_count, 3)  # 1 in log.dart, 2 in mixed.dart

    def test_fix_violation(self):
        """Test fixing violations."""
        checker = LoggingChecker([str(self.test_dir)], auto_fix=True)
        violations = checker.find_violations()
        
        # Fix a debugPrint violation
        debug_print_violation = next(v for v in violations if v.violation_type == 'debugPrint')
        success, message = checker.fix_violation(debug_print_violation)
        
        # Check if fix was successful
        self.assertTrue(success)
        self.assertEqual(message, "debugPrint -> AppLogger.d")
        
        # Check if file was modified correctly
        with open(debug_print_violation.file_path, 'r') as f:
            content = f.read()
            self.assertIn("AppLogger.d('This will be detected')", content)
            self.assertIn("import 'package:memverse/src/utils/app_logger.dart'", content)

    def test_check_and_fix_local_mode(self):
        """Test check_and_fix in local mode with auto_fix."""
        checker = LoggingChecker([str(self.test_dir)], mode=Mode.LOCAL, auto_fix=True)
        result = checker.check_and_fix()
        
        # Should successfully fix all violations
        self.assertTrue(result)
        
        # Check if violations were fixed
        new_checker = LoggingChecker([str(self.test_dir)])
        new_violations = new_checker.find_violations()
        self.assertEqual(len(new_violations), 0)
        
        # Check if AppLogger import was added to all fixed files
        for file_name in ["debug_print.dart", "log.dart", "mixed.dart"]:
            with open(self.test_dir / file_name, 'r') as f:
                content = f.read()
                self.assertIn("import 'package:memverse/src/utils/app_logger.dart'", content)

    def test_check_and_fix_ci_mode(self):
        """Test check_and_fix in CI mode."""
        checker = LoggingChecker([str(self.test_dir)], mode=Mode.CI, auto_fix=True)
        result = checker.check_and_fix()
        
        # Should fail in CI mode when violations are found
        self.assertFalse(result)
        
        # Files should not be modified in CI mode
        with open(self.test_dir / "debug_print.dart", 'r') as f:
            content = f.read()
            self.assertIn("debugPrint('This will be detected')", content)
            self.assertNotIn("AppLogger.d", content)


class TestExamples(unittest.TestCase):
    """
    Example-based tests that demonstrate how the logging checker works.
    These tests serve as documentation for users.
    """

    def test_example_valid_code(self):
        """Example: Valid code with AppLogger usage."""
        with tempfile.TemporaryDirectory() as temp_dir:
            # Create a file with valid logging
            file_path = os.path.join(temp_dir, "valid.dart")
            with open(file_path, "w") as f:
                f.write("""
import 'package:memverse/src/utils/app_logger.dart';

void someFunction() {
  // Valid logging usage
  AppLogger.d('Debug message');
  AppLogger.e('Error occurred', error, stackTrace);
  
  // False positives that should not be detected
  someObject.log('Not a violation');
  analyticsLog('Not a violation');
}
""")
            
            # Check using the logging checker
            checker = LoggingChecker([temp_dir])
            violations = checker.find_violations()
            
            # No violations expected
            self.assertEqual(len(violations), 0)

    def test_example_prohibited_logging(self):
        """Example: Code with prohibited logging methods."""
        with tempfile.TemporaryDirectory() as temp_dir:
            # Create a file with prohibited logging
            file_path = os.path.join(temp_dir, "prohibited.dart")
            with open(file_path, "w") as f:
                f.write("""
import 'dart:developer';
import 'package:flutter/foundation.dart';

void someFunction() {
  // These are prohibited and will be detected
  debugPrint('This is prohibited');
  log('This is also prohibited');
  
  // These are commented out and should be ignored
  // debugPrint('Ignored');
  // log('Also ignored');
}
""")
            
            # Check using the logging checker
            checker = LoggingChecker([temp_dir])
            violations = checker.find_violations()
            
            # Should find 2 violations
            self.assertEqual(len(violations), 2)
            
            # Check violation types
            violation_types = [v.violation_type for v in violations]
            self.assertIn('debugPrint', violation_types)
            self.assertIn('log', violation_types)

    def test_example_auto_fix(self):
        """Example: Auto-fixing prohibited logging methods."""
        with tempfile.TemporaryDirectory() as temp_dir:
            # Create a file with prohibited logging
            file_path = os.path.join(temp_dir, "fix_example.dart")
            with open(file_path, "w") as f:
                f.write("""
import 'dart:developer';

void someFunction() {
  log('This will be auto-fixed', name: 'example');
}
""")
            
            # Check and fix using the logging checker
            checker = LoggingChecker([temp_dir], auto_fix=True)
            checker.check_and_fix()
            
            # Check if the file was fixed correctly
            with open(file_path, 'r') as f:
                content = f.read()
                
                # Should have replaced log with AppLogger.d
                self.assertIn("AppLogger.d('This will be auto-fixed'", content)
                
                # Should have added AppLogger import
                self.assertIn("import 'package:memverse/src/utils/app_logger.dart'", content)


if __name__ == '__main__':
    unittest.main()