# Loom Recording Script: Maestro POC Demo

## Recording Overview

**Purpose**: Educational demo explaining what Maestro is and how it works  
**Target Audience**: Team members new to Maestro testing  
**Duration**: 5-7 minutes  
**Focus**: Maestro fundamentals + live POC demonstration

## Pre-Recording Setup

### Environment Preparation

- [ ] Android device connected and visible
- [ ] App installed and ready to launch
- [ ] Terminal window prepared with commands
- [ ] Screen recording settings optimized (1080p, clear audio)
- [ ] Loom recording ready to start

### Demo Materials Ready

- [ ] `June1_maestro_demo.md` open for reference
- [ ] `maestro_prep.sh` script ready to execute
- [ ] `maestro/flows/login/empty_login_validation.yaml` ready to run
- [ ] Browser tab with Maestro documentation open

## Recording Script

### 🎬 Opening (30 seconds)

**[Screen: Desktop with project folder visible]**

> "Hi everyone! Today I'm going to show you Maestro - a revolutionary mobile UI testing framework
> that makes testing iOS and Android apps incredibly simple.
>
> By the end of this demo, you'll understand what Maestro is, why it's amazing, and see it working
> live on our Memverse app. Let's dive in!"

### 📚 What is Maestro? (90 seconds)

**[Screen: Switch to browser with Maestro documentation]**

> "First, what is Maestro?
>
> Maestro is a mobile UI testing framework that lets you write tests using simple YAML files - no
> complex programming required. Think of it as automating exactly what a human would do: tap buttons,
> enter text, and verify what appears on screen.
>
> **[Point to key features on screen]**
> - Works on both iOS and Android
> - Tests run on real devices or emulators
> - Takes screenshots automatically
> - Can record videos of test execution
> - Uses simple, readable YAML syntax
>
> The best part? Anyone can write these tests - QA engineers, developers, even non-technical team
> members!"

### 🔧 Live Setup Demo (60 seconds)

**[Screen: Switch to terminal in project directory]**

> "Now let's see Maestro in action. I'm going to use our automated setup script that checks
> everything and gets us ready for testing.
>
> **[Type command while explaining]**
> ```bash
> ./maestro_prep.sh
> ```
>
> Watch how this script automatically:
> - Checks if all required tools are installed
> - Verifies our Android device is connected
> - Builds our Flutter app with the correct configuration
> - Installs the app on the device
> - Confirms everything is ready for testing
>
> **[Show colored output as script runs]**
> See those green checkmarks? That means everything is working perfectly!"

### 🎯 Live Test Execution (120 seconds)

**[Screen: Terminal + visible Android device]**

> "Now for the exciting part - let's run an actual test!
>
> This test simulates a common user mistake: trying to login without entering username or password.
> Our app should show helpful error messages.
>
> **[Type command]**
> ```bash
> maestro test maestro/flows/login/empty_login_validation.yaml
> ```
>
> **[Watch test execute, narrate what's happening]**
> - Maestro connects to our device
> - App launches automatically
> - It taps the Login button without entering credentials
> - App shows validation errors: 'Please enter your username' and 'Please enter your password'
> - Test captures screenshots at each step
> - All assertions pass with green checkmarks!
>
> **[Show device screen during execution]**
> You can see on the device exactly what's happening - it's like watching a robot user interact with
> our app!"

### 📸 Results Review (90 seconds)

**[Screen: Terminal showing success + file explorer with screenshots]**

> "The test completed successfully! Let's look at what Maestro captured for us.
>
> **[Open screenshot directory]**
> ```bash
> open ~/.maestro/tests/$(ls -t ~/.maestro/tests | head -1)
> ```
>
> **[Show screenshots one by one]**
> Here are the automatic screenshots:
> - 'login_screen_empty' - Shows the initial login screen
> - 'empty_login_validation_error' - Captures the error state
> - 'validation_messages_visible' - Confirms error messages appeared
>
> This visual documentation is incredibly valuable for debugging and demonstrating that our
> validation works correctly!"

### 🎥 Video Recording Capabilities (60 seconds)

**[Screen: Terminal with video recording commands]**

> "Maestro can also record videos of test execution. There are two approaches:
>
> **Local Recording**: Records your actual device screen - higher quality, immediate access
> **Remote Recording**: Uses Maestro Cloud - standardized environment, easy sharing
>
> **[Show example commands]**
> ```bash
> # Local recording (what we just did)
> maestro test maestro/flows/login/empty_login_validation.yaml --format junit
> 
> # Remote recording (requires Maestro Cloud)
> maestro cloud maestro/flows/login/empty_login_validation.yaml
> ```
>
> The choice depends on your needs - local for development, remote for CI/CD and team sharing."

### 🚀 Next Steps & Benefits (30 seconds)

**[Screen: Back to project structure showing test files]**

> "What makes this powerful is how easy it is to expand:
> - Add more test scenarios by creating new YAML files
> - Test happy paths, error cases, edge conditions
> - Run tests automatically in CI/CD pipelines
> - Anyone on the team can write and maintain these tests
>
> **[Show file structure]**
> All our tests are organized in the maestro/flows directory, ready to grow with our needs."

### 🎯 Closing (30 seconds)

**[Screen: Desktop with successful test results visible]**

> "That's Maestro in a nutshell! In just 5 minutes, we've:
> - Set up a complete testing environment
> - Executed a real-world test scenario
> - Captured visual documentation
> - Validated our app's error handling
>
> The best part? This entire process can be repeated by anyone on the team with zero Maestro
> experience, thanks to our automated setup and clear documentation.
>
> Questions? Check out our June1_maestro_demo.md guide for step-by-step instructions. Happy
> testing!"

## Post-Recording Checklist

### Video Quality

- [ ] Audio is clear and professional
- [ ] Screen recording is crisp (1080p minimum)
- [ ] All text in terminal/code is readable
- [ ] Device screen interactions are visible
- [ ] No background noise or distractions

### Content Coverage

- [ ] Explained what Maestro is and its benefits
- [ ] Demonstrated automated setup process
- [ ] Showed live test execution with real results
- [ ] Explained screenshot/video recording capabilities
- [ ] Covered both local and remote recording options
- [ ] Provided clear next steps

### Technical Accuracy

- [ ] All commands executed successfully
- [ ] Test results were authentic (not staged)
- [ ] Screenshots showed actual app behavior
- [ ] Documentation references were accurate
- [ ] No technical errors or confusion

## Distribution Notes

### Loom Settings

- **Title**: "Maestro Mobile Testing POC - What It Is & How It Works"
- **Privacy**: Team/Company access as appropriate
- **Description**: "Live demonstration of Maestro mobile UI testing framework using our Memverse
  app. Shows setup, execution, and results of automated testing."

### Sharing Strategy

- Embed in JIRA story for immediate context
- Share in team Slack/communication channels
- Include in onboarding materials for new team members
- Reference in technical documentation and wiki

### Follow-up Resources

- Link to `June1_maestro_demo.md` for hands-on practice
- Reference `maestro_prep.sh` for automated setup
- Point to `maestro_rules.txt` for best practices
- Connect to full happy path story for advanced implementation

---

**Recording Duration Target**: 5-7 minutes  
**Key Message**: Maestro makes mobile testing simple, powerful, and accessible to everyone  
**Call to Action**: Try the POC using our automated setup and documentation