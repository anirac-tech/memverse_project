#!/usr/bin/env python3
"""
Script for checking prohibited logging methods in Dart files.
Can be used by both the check_before_commit.sh script and CI pipeline.
"""

import argparse
import os
import re
import sys
import subprocess
from typing import List, Dict, Tuple, Optional
from enum import Enum
from pathlib import Path


class Colors:
    """Terminal colors for output formatting."""
    GREEN = '\033[0;32m'
    RED = '\033[0;31m'
    YELLOW = '\033[0;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'  # No Color


class Mode(Enum):
    """Operation mode of the script."""
    LOCAL = "local"
    CI = "ci"


class LoggingViolation:
    """Represents a logging violation found in a file."""
    def __init__(self, file_path: str, line_number: int, line_content: str, violation_type: str):
        self.file_path = file_path
        self.line_number = line_number
        self.line_content = line_content.strip()
        self.violation_type = violation_type

    def __str__(self) -> str:
        return f"{self.file_path}:{self.line_number}: {self.line_content}"


class LoggingChecker:
    """Main class for checking prohibited logging methods."""

    # Patterns to identify prohibited logging methods
    PROHIBITED_PATTERNS = [
        (r'(?<!\w)debugPrint\(', 'debugPrint'),
        (r'(?<!\w)log\(', 'log')
    ]

    def __init__(self, directories: List[str], mode: Mode = Mode.LOCAL, auto_fix: bool = False):
        """Initialize the checker.

        Args:
            directories: List of directories to scan
            mode: Operation mode (local or ci)
            auto_fix: Whether to automatically fix violations
        """
        self.directories = directories
        self.mode = mode
        self.auto_fix = auto_fix and mode == Mode.LOCAL  # Only allow auto-fix in local mode
        self.violations: List[LoggingViolation] = []

    def print_success(self, message: str) -> None:
        """Print a success message."""
        if self.mode == Mode.LOCAL:
            print(f"{Colors.GREEN}✓ {message}{Colors.NC}")
        else:
            print(message)

    def print_error(self, message: str) -> None:
        """Print an error message."""
        if self.mode == Mode.LOCAL:
            print(f"{Colors.RED}✗ {message}{Colors.NC}")
        else:
            print(f"::error::{message}")

    def print_info(self, message: str) -> None:
        """Print an info message."""
        if self.mode == Mode.LOCAL:
            print(f"{Colors.YELLOW}➤ {message}{Colors.NC}")
        else:
            print(message)

    def find_dart_files(self) -> List[Path]:
        """Find all dart files in the specified directories.

        Returns:
            List of dart file paths
        """
        dart_files = []
        for directory in self.directories:
            for root, _, files in os.walk(directory):
                for file in files:
                    if file.endswith('.dart'):
                        dart_files.append(Path(os.path.join(root, file)))
        return dart_files

    def is_line_commented(self, line: str) -> bool:
        """Check if a line is commented out.

        Args:
            line: The line to check

        Returns:
            True if the line is commented out, False otherwise
        """
        # Check if the line is entirely a comment
        if line.strip().startswith("//"):
            return True
        
        # For potential inline comments, we need to be more careful
        # Split the line by '//' and check if the occurrence is within a string
        parts = line.split('//')
        
        # If there's only one part, there's no comment
        if len(parts) == 1:
            return False
        
        # If we find '//' with an odd number of quotes before it,
        # it's inside a string and not a real comment
        full_line = line
        comment_pos = full_line.find('//')
        if comment_pos != -1:
            before_comment = full_line[:comment_pos]
            # Count unescaped quotes
            quote_count = before_comment.count('"') - before_comment.count('\\"')
            # If odd number of quotes, '//' is inside a string
            return quote_count % 2 == 0
        
        return False

    def find_violations(self) -> List[LoggingViolation]:
        """Find logging violations in dart files.

        Returns:
            List of violations
        """
        violations = []
        dart_files = self.find_dart_files()
        
        for file_path in dart_files:
            with open(file_path, 'r') as file:
                for line_num, line in enumerate(file, 1):
                    if self.is_line_commented(line):
                        continue
                    
                    for pattern, violation_type in self.PROHIBITED_PATTERNS:
                        if re.search(pattern, line):
                            violation = LoggingViolation(
                                str(file_path), 
                                line_num, 
                                line, 
                                violation_type
                            )
                            violations.append(violation)
        
        return violations

    def fix_violation(self, violation: LoggingViolation) -> Tuple[bool, str]:
        """Fix a logging violation.

        Args:
            violation: The violation to fix

        Returns:
            (success, message) tuple
        """
        try:
            # Read the file
            with open(violation.file_path, 'r') as file:
                content = file.readlines()
            
            # Replace the line
            line_index = violation.line_number - 1
            original_line = content[line_index]
            
            if violation.violation_type == 'debugPrint':
                # Simple replacement
                content[line_index] = re.sub(r'(?<!\w)debugPrint\(', 'AppLogger.d(', original_line)
                fix_type = "debugPrint -> AppLogger.d"
            elif violation.violation_type == 'log':
                # For log() calls, we need to handle the 'name' parameter if present
                if ', name:' in original_line:
                    # Remove the 'name' parameter
                    # Find the opening parenthesis
                    open_paren = original_line.find('log(')
                    if open_paren == -1:
                        open_paren = original_line.find('log (')
                    
                    # Find the corresponding closing parenthesis
                    if open_paren != -1:
                        open_paren = original_line.find('(', open_paren)
                        if open_paren != -1:
                            # Count parentheses to find the matching closing one
                            paren_count = 1
                            for i in range(open_paren + 1, len(original_line)):
                                if original_line[i] == '(':
                                    paren_count += 1
                                elif original_line[i] == ')':
                                    paren_count -= 1
                                
                                if paren_count == 0:
                                    # We found the matching closing parenthesis
                                    close_paren = i
                                    break
                            
                            # Get the content between parentheses
                            args = original_line[open_paren + 1:close_paren]
                            
                            # Split by commas not inside quotes
                            # This is a simplified approach that may not handle all cases
                            in_quotes = False
                            arg_parts = []
                            current_part = ""
                            for char in args:
                                if char == '"' and (len(current_part) == 0 or current_part[-1] != '\\'):
                                    in_quotes = not in_quotes
                                    current_part += char
                                elif char == ',' and not in_quotes:
                                    # We found a separator
                                    arg_parts.append(current_part.strip())
                                    current_part = ""
                                else:
                                    current_part += char
                            
                            if current_part:
                                arg_parts.append(current_part.strip())
                            
                            # Remove any args with 'name:'
                            filtered_args = [arg for arg in arg_parts if not arg.startswith('name:')]
                            
                            # Reconstruct the line
                            args_str = ', '.join(filtered_args)
                            content[line_index] = original_line[:open_paren].replace('log', 'AppLogger.d') + '(' + args_str + ')' + original_line[close_paren+1:]
                else:
                    # Simple replacement for log() without name parameter
                    content[line_index] = re.sub(r'(?<!\w)log\(', 'AppLogger.d(', original_line)
                
                fix_type = "log -> AppLogger.d"
            else:
                return False, f"Unknown violation type: {violation.violation_type}"
            
            # Write back to the file
            with open(violation.file_path, 'w') as file:
                file.writelines(content)
            
            # Check if AppLogger import is needed
            self.ensure_app_logger_import(violation.file_path)
            
            return True, fix_type
        except Exception as e:
            return False, str(e)

    def ensure_app_logger_import(self, file_path: str) -> None:
        """Ensure the AppLogger import is present in the file.

        Args:
            file_path: Path to the file to check
        """
        import_line = "import 'package:memverse/src/utils/app_logger.dart';"
        
        with open(file_path, 'r') as file:
            content = file.read()
        
        if "package:memverse/src/utils/app_logger.dart" not in content:
            with open(file_path, 'r') as file:
                lines = file.readlines()
            
            # Find a good place to insert the import
            # Look for the last import statement
            import_index = -1
            for i, line in enumerate(lines):
                if line.strip().startswith('import '):
                    import_index = i
            
            if import_index != -1:
                # Insert after the last import statement
                lines.insert(import_index + 1, f"{import_line}\n")
            else:
                # Insert at the beginning of the file
                lines.insert(0, f"{import_line}\n")
            
            with open(file_path, 'w') as file:
                file.writelines(lines)
            
            self.print_info(f"Added AppLogger import to {file_path}")

    def check_and_fix(self) -> bool:
        """Run the check and optionally fix violations.

        Returns:
            True if no violations were found or all were fixed, False otherwise
        """
        self.violations = self.find_violations()
        
        if not self.violations:
            self.print_success("No prohibited logging methods found")
            return True
        
        if self.mode == Mode.CI:
            self.print_error("Found prohibited logging methods. Please use AppLogger.d() or AppLogger.e() instead:")
            for violation in self.violations:
                print(violation)
            return False
        else:
            self.print_error("Found prohibited logging methods.")
            print("Offending lines:")
            for violation in self.violations:
                print(f"  {violation}")
            
            if self.auto_fix:
                self.print_info("Attempting automatic fixes...")
                fixed_count = 0
                
                for violation in self.violations:
                    success, fix_message = self.fix_violation(violation)
                    if success:
                        self.print_info(f"Fixed {fix_message} in {violation.file_path}:{violation.line_number}")
                        fixed_count += 1
                    else:
                        self.print_error(f"Failed to fix {violation.file_path}:{violation.line_number} - {fix_message}")
                
                if fixed_count == len(self.violations):
                    self.print_info(f"Successfully fixed {fixed_count} violations.")
                    return True
                else:
                    self.print_error(f"Fixed {fixed_count}/{len(self.violations)} violations.")
                    return False
            else:
                return False


def main():
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(description='Check for prohibited logging methods in Dart files.')
    parser.add_argument('--mode', choices=['local', 'ci'], default='local',
                        help='Operating mode: local or CI (default: local)')
    parser.add_argument('--auto-fix', action='store_true',
                        help='Automatically fix violations (only in local mode)')
    parser.add_argument('--directories', nargs='+', default=['lib', 'test'],
                        help='Directories to scan (default: lib test)')
    args = parser.parse_args()

    mode = Mode.LOCAL if args.mode == 'local' else Mode.CI
    checker = LoggingChecker(args.directories, mode=mode, auto_fix=args.auto_fix)
    
    success = checker.check_and_fix()
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()