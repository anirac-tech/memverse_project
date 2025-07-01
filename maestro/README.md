# Memverse Maestro Tests

This directory contains automated UI tests for the Memverse app
using [Maestro](https://maestro.mobile.dev/).

## Directory Structure

- `flows/` - Test flows for the Memverse app
    - `login/` - Login-related tests
    - `memverse_dot_com/` - Tests for the memverse.com website
    - Other test flows for specific app features

- `scripts/` - Helper scripts for running tests

## Running Tests

### Prerequisites

1. Install Maestro CLI:

```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
```

2. Connect a device or start an emulator:

```bash
# List available devices
flutter devices
```

### Running a Test Flow

```bash
# Run a specific test flow
maestro test maestro/flows/happy_path.yaml

# Run with verbose output
maestro test -v maestro/flows/happy_path.yaml
```

### Using Helper Scripts

```bash
# Run memverse.com website tests
./maestro/scripts/run_memverse_dot_com_tests.sh
```

## Guidelines

- Do not clear app state unless specifically testing fresh app state
- App package name is `com.spiritflightapps.memverse`
- Take screenshots before and after critical actions for debugging
- Use `waitForAnimationToEnd` after user interactions
- See `maestro_rules.txt` for complete testing guidelines</code_edit>