# JIRA Story: Maestro Flow Testing with Video Recording

## Story Overview

**Title**: Implement Maestro Flow Tests for Reasonable User Journeys with Video Documentation
**Type**: Task
**Priority**: Medium
**Estimate**: 5 Story Points
**Dependencies**: Basic app functionality and environment variables setup

## User Story

As a developer and product owner, I want to create Maestro flow tests for reasonable user journeys
so that I can validate end-to-end functionality and generate video documentation of the app's
behavior for stakeholders and QA teams.

## Acceptance Criteria

### Must Have

- [ ] **Maestro Setup**: Configure Maestro CLI and test environment
- [ ] **Core Flow Tests**: Authentication and verse practice user journeys
- [ ] **Video Recording**: Generate MP4 videos of test executions
- [ ] **Android Physical Device**: Focus on Android device testing (Maestro iOS limitations noted)
- [ ] **Environment Variables**: Use test credentials from environment
- [ ] **Reasonable Flows**: Test happy path and basic error scenarios only
- [ ] **Documentation**: Video library for stakeholder demos

### Should Have

- [ ] **Multiple Flow Variations**: Different verse reference scenarios
- [ ] **Error Flow Documentation**: Video capture of validation errors
- [ ] **Performance Timing**: Measure flow execution times
- [ ] **Automated Execution**: Script to run all flows and generate videos

### Could Have

- [ ] **Multi-Device Recording**: Test on different Android devices
- [ ] **Comparison Videos**: Before/after for feature changes
- [ ] **Interactive Demos**: Videos for user onboarding documentation

## Technical Requirements

### Maestro Configuration

```yaml
# maestro/config.yaml
appId: com.spiritflightapps.memverse
env:
  USERNAME: ${MEMVERSE_USERNAME}
  PASSWORD: ${MEMVERSE_PASSWORD}
  CLIENT_ID: ${MEMVERSE_CLIENT_ID}
```

### Flow Files to Create

1. `maestro/flows/complete_login_flow.yaml` - Full authentication journey
2. `maestro/flows/verse_practice_happy_path.yaml` - Successful verse references
3. `maestro/flows/verse_practice_validation_errors.yaml` - Input validation scenarios
4. `maestro/flows/app_navigation_flow.yaml` - UI navigation and logout

### Video Output Structure

```
videos/
├── complete_login_flow.mp4
├── verse_practice_happy_path.mp4
├── verse_practice_validation_errors.mp4
├── app_navigation_flow.mp4
└── combined_user_journey.mp4
```

## Implementation Tasks

### Phase 1: Maestro Environment Setup (1 point)

- [ ] Verify Maestro CLI installation and Android device connectivity
- [ ] Create Maestro configuration files
- [ ] Test basic app launch and recording capability
- [ ] Document Android device requirements and iOS limitations

### Phase 2: Core Flow Development (2 points)

- [ ] Create authentication flow with environment variables
- [ ] Develop verse practice flows (Col 1:17 correct, Gal 5:2 almost correct)
- [ ] Add validation error flows (empty input, invalid format)
- [ ] Create logout and navigation flows

### Phase 3: Video Recording Setup (1 point)

- [ ] Configure Maestro recording parameters
- [ ] Set up video quality and duration settings
- [ ] Create automated recording scripts
- [ ] Test video output quality and file sizes

### Phase 4: Flow Execution and Documentation (1 point)

- [ ] Execute all flows and generate videos
- [ ] Create video catalog with descriptions
- [ ] Validate flow reliability and timing
- [ ] Document flow execution procedures

## Maestro Flow Examples

### Complete Login Flow

```yaml
# maestro/flows/complete_login_flow.yaml
appId: com.spiritflightapps.memverse
---
- launchApp
- tapOn:
    id: login_username_field
- inputText: ${USERNAME}
- tapOn:
    id: login_password_field
- inputText: ${PASSWORD}
- tapOn:
    id: login_button
- assertVisible: "Memverse Reference Test"
- takeScreenshot: login_success.png
```

### Verse Practice Happy Path

```yaml
# maestro/flows/verse_practice_happy_path.yaml
appId: com.spiritflightapps.memverse
---
- runFlow: complete_login_flow.yaml
- assertVisible: "He is before all things"
- tapOn:
    id: reference_input_field
- inputText: "Col 1:17"
- tapOn:
    id: submit_button
- assertVisible: "Correct!"
- takeScreenshot: correct_answer.png
- assertVisible: "It is for freedom"
- tapOn:
    id: reference_input_field
- inputText: "Gal 5:2"
- tapOn:
    id: submit_button
- assertVisible: "Not quite right"
- takeScreenshot: almost_correct_answer.png
```

### Validation Error Flow

```yaml
# maestro/flows/verse_practice_validation_errors.yaml
appId: com.spiritflightapps.memverse
---
- runFlow: complete_login_flow.yaml
- tapOn:
    id: submit_button
- assertVisible: "Reference cannot be empty"
- takeScreenshot: empty_validation.png
- tapOn:
    id: reference_input_field
- inputText: "invalid format"
- tapOn:
    id: submit_button
- assertVisible: "Invalid reference format"
- takeScreenshot: format_validation.png
```

## Video Recording Configuration

### Recording Script

```bash
#!/bin/bash
# scripts/record_maestro_flows.sh

set -e

DEVICE_ID="48050DLAQ0091E"  # Android physical device
VIDEO_DIR="videos"
mkdir -p $VIDEO_DIR

echo "🎥 Starting Maestro Flow Video Recording"

# Set environment variables
export MEMVERSE_USERNAME="${MEMVERSE_USERNAME:-test@example.com}"
export MEMVERSE_PASSWORD="${MEMVERSE_PASSWORD:-testpass}"
export MEMVERSE_CLIENT_ID="${MEMVERSE_CLIENT_ID:-test_client}"

# Record each flow
flows=(
  "complete_login_flow"
  "verse_practice_happy_path"
  "verse_practice_validation_errors"
  "app_navigation_flow"
)

for flow in "${flows[@]}"; do
  echo "📱 Recording flow: $flow"
  maestro test maestro/flows/${flow}.yaml \
    --device $DEVICE_ID \
    --record ${VIDEO_DIR}/${flow}.mp4 \
    --duration 120
  echo "✅ Completed: ${flow}.mp4"
done

echo "🎬 All flow videos recorded successfully!"
echo "📁 Videos saved to: $VIDEO_DIR/"
```

### Quality and Performance Settings

- **Resolution**: 1080p for clear detail
- **Frame Rate**: 30fps for smooth playback
- **Duration**: Auto-detect with 2-minute maximum
- **Compression**: Optimized for file size vs quality balance

## Reasonable Flow Scope

### Included Scenarios (Reasonable)

✅ **Happy Path Authentication**: Login with valid credentials
✅ **Successful Verse Practice**: Correct reference (Col 1:17)
✅ **Almost Correct Scenario**: Close reference (Gal 5:2 for Gal 5:1)
✅ **Basic Validation**: Empty input and invalid format errors
✅ **Standard Navigation**: Logout and basic UI interactions
✅ **Answer History**: View previous attempts

### Excluded Scenarios (Unreasonable for Maestro)

❌ **Network Failure Simulation**: Cannot reliably simulate network issues
❌ **Complex Error States**: Extreme edge cases difficult to reproduce
❌ **Performance Under Load**: Not suitable for load testing
❌ **Multi-App Interactions**: Deep links and external app triggers
❌ **Platform-Specific Edge Cases**: iOS simulator limitations noted

## Success Criteria

### Definition of Done

- [ ] All Maestro flows execute successfully on Android physical device
- [ ] High-quality videos generated for each flow scenario
- [ ] Video catalog created with descriptions and use cases
- [ ] Automated recording script works reliably
- [ ] Environment variable integration functional
- [ ] Documentation updated with video locations and purposes
- [ ] Flow execution times documented for performance baseline

### Video Quality Standards

- **Visual Clarity**: UI elements clearly visible and readable
- **Audio**: No audio required (silent videos acceptable)
- **Timing**: Natural pacing that matches real user behavior
- **Completeness**: Full flow from start to expected end state
- **File Size**: Optimized for sharing and storage (under 50MB per video)

## Risk Assessment

### High Risk

- **Android Device Dependency**: Tests require specific physical device
- **Maestro iOS Limitations**: Cannot reliably test iOS flows
- **App State Dependencies**: Flows may interfere with each other
- **Recording Failures**: Video recording may fail due to device issues

### Mitigation Strategies

- Test on multiple Android devices if available
- Reset app state between flow recordings
- Add retry logic for failed recordings
- Maintain fallback screenshots if video recording fails
- Document known limitations with iOS testing

## Video Use Cases

### For Development Team

- **Regression Testing**: Compare videos before/after changes
- **Bug Reproduction**: Share exact steps leading to issues
- **Feature Validation**: Confirm new features work as expected

### For Product/Stakeholders

- **Demo Material**: Show app functionality to stakeholders
- **User Story Validation**: Confirm acceptance criteria met
- **Release Documentation**: Visual proof of feature completion

### For QA Team

- **Test Case Documentation**: Visual test case references
- **Training Material**: Onboard new QA team members
- **Issue Communication**: Clear bug reports with video evidence

## Resources and Dependencies

### Technical Requirements

- Android physical device (48050DLAQ0091E or equivalent)
- Maestro CLI installed and configured
- Environment variables for test credentials
- Sufficient device storage for video files

### Documentation References

- `temporarily_ditl.md` - Current Maestro setup and limitations
- `live_integration_tests_exceptions.md` - Understanding testing boundaries
- Maestro CLI documentation for recording features

## Notes

This story focuses on practical, executable user flows that provide value for documentation and
validation without attempting to test edge cases that are better handled by other testing
approaches. The emphasis on video recording makes this particularly valuable for stakeholder
communication and QA documentation.

The Android device focus is intentional based on known Maestro iOS simulator limitations documented
in the project.