# AI Mistakes Log

## 2025-05-31 10:33:45 AM - Hot Reload Flag Error

**Context**: Reference to Gemini conversation: https://g.co/gemini/share/de7ff85bc9b1

**Mistake**: Referenced `--hot` flag for hot reload in Flutter/Maestro documentation
**Issue**: The `--hot` flag doesn't exist in Flutter CLI commands
**Correct Approach**: Hot reload is enabled by default in `flutter run` and triggered with `r` key
press
**Files Affected**:

- firebender.md (needs correction)
- Any other documentation referencing `--hot` flag

**Learning**: Always verify CLI flags exist before documenting them. Flutter uses hot reload by
default in debug mode without explicit flags.

**Fix Required**: Remove all references to `--hot` flag and replace with correct Flutter hot reload
documentation.