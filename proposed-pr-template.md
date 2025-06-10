<!--
  Proposed PR Template - Incorporating AI Reviews and PWA Checks

  This template suggests additions to the standard PR process to leverage AI assistance
  and ensure PWA functionality is reviewed.
-->

## Description

[ Provide a description of your changes below and a general summary in the title ]

## Jira Tickets

- [Link to relevant Jira ticket(s)]

## Changes vs. Origin/Main

[ Detail the key changes introduced in this branch compared to the main branch ]

## PostHog Analytics Testing (Web Demo Preview)

*Test PostHog integration and analytics tracking from the Netlify web demo preview.*

### Prerequisites

- [ ] Netlify preview deployment is live and accessible
- [ ] PostHog project is configured with correct CLIENT_ID
- [ ] Access to PostHog dashboard: [https://app.posthog.com/](https://app.posthog.com/)

### Step-by-Step Testing Instructions

#### 1. Access Web Demo Preview & Setup

- [ ] Open Netlify preview URL in browser
- [ ] Verify app loads correctly with `--dart-define=CLIENT_ID=$CLIENT_ID` configuration
- [ ] Open browser developer tools (F12) → Console tab
- [ ] Clear console to see fresh PostHog events

#### 2. Test Login Flow & Event Tracking

- [ ] **Login Screen Events**:
    - Navigate to login screen
    - Verify Console shows: PostHog initialization messages
    - Expected Console: `PostHog configured for web with session replay enabled`

- [ ] **Successful Login**:
    - Enter username: `njwandroid@gmail.com` (or your test credentials)
    - Enter password: `[your test password]`
    - Click login button
    - **Expected PostHog Events**: `user_login` with username property
    - **Expected Console**: Login success tracking messages

- [ ] **Post-Login Page Load**:
    - Wait for main verse practice page to load
    - **Expected PostHog Events**:
        - `app_opened`
        - `practice_session_start`
        - `web_page_view` with properties: `{page_name: 'memverse_practice_page', platform: 'web'}`
        - `web_browser_info` with user agent data

#### 3. Test Verse Practice Analytics (Happy Path Flow)

- [ ] **First Verse - Correct Answer (Green Feedback)**:
    - Verify verse text displays: "He is before all things, and in him all things hold together."
    - **Expected PostHog Event**: `verse_displayed` with `{verse_reference: 'Col 1:17'}`
    - Enter reference: `Col 1:17`
    - Click submit button (key: "submit-ref")
    - **Expected PostHog Event**: `verse_correct` with `{verse_reference: 'Col 1:17'}`
    - **Expected UI**: Green snackbar with "Correct!" message
    - **Expected Console**: Success tracking message

- [ ] **Second Verse - Nearly Correct Answer (Orange Feedback)**:
    - Wait for next verse to load (~1.5 seconds)
    - Verify verse text displays: "It is for freedom that Christ has set us free"
    - **Expected PostHog Event**: `verse_displayed` with `{verse_reference: 'Gal 5:1'}`
    - Enter reference: `Gal 5:2` (intentionally one verse off)
    - Click submit button
    - **Expected PostHog Event**: `verse_nearly_correct` with
      `{verse_reference: 'Gal 5:1', user_answer: 'Gal 5:2'}`
    - **Expected UI**: Orange snackbar with "Not quite right" message

- [ ] **Third Verse - Incorrect Answer (Red Feedback)** (if implemented):
    - Wait for next verse to load
    - Enter completely wrong reference (e.g., "John 1:1")
    - Click submit button
    - **Expected PostHog Event**: `verse_incorrect` with verse reference and user answer properties

#### 4. Verify PostHog Dashboard Real-time

- [ ] **Login to PostHog Dashboard**:
    - Go to [https://app.posthog.com/](https://app.posthog.com/)
    - Select correct project (CLIENT_ID should match)
        - Navigate to "Events" or "Live Events" tab

- [ ] **Real-time Event Verification** (within 30-60 seconds):
    - **Login Events**: Look for `user_login` event with username
    - **Page Events**: `app_opened`, `practice_session_start`, `web_page_view`
    - **Verse Events**: `verse_displayed`, `verse_correct`, `verse_nearly_correct`
    - **Session Data**: Verify user properties include platform: "web"

#### 5. Test Feedback Feature Analytics

- [ ] **Trigger Feedback**:
    - Click the feedback button (🗩 icon) in app bar
    - **Expected PostHog Event**: `feedback_trigger`
    - Complete or cancel feedback dialog
    - Verify event appears in PostHog dashboard

#### 6. Debug Common Issues

- [ ] **If events not appearing in PostHog**:
    - Check Console for JavaScript errors
    - Look for POST requests to `us.i.posthog.com` in Network tab
    - Verify CLIENT_ID environment variable matches PostHog project
    - Check PostHog project settings for correct API key

- [ ] **If login events missing**:
    - Verify successful login (no error messages)
    - Check that auth provider is calling `trackLogin(username)`
    - Test with valid credentials: `njwandroid@gmail.com`

- [ ] **If verse events missing**:
    - Ensure you're submitting valid verse references
    - Check that verse text matches exactly what's expected
    - Verify answer format: "Book Chapter:Verse" (e.g., "Col 1:17")

#### 7. Cross-Browser Web Testing

- [ ] **Chrome/Edge**:
    - Complete steps 1-6 above
    - Verify PostHog session replay works
    - Check Network tab for successful API calls

- [ ] **Firefox**:
    - Test basic login and verse practice flow
    - Verify no console errors related to PostHog
    - Confirm events tracked correctly

#### 8. Performance & Session Replay Check

- [ ] **Session Recording Verification**:
    - In PostHog dashboard, go to "Session Recordings"
    - Look for your web session (should appear within minutes)
    - Verify it captures login and verse practice interactions

- [ ] **Network Performance**:
    - Check Network tab: PostHog requests should be < 100KB each
    - No excessive API calls (should be 1 request per event)
    - Response times should be < 2 seconds

### Expected PostHog Dashboard Results

After completing the happy path test, PostHog should show:

- [ ] **User Login**: `user_login` with username property
- [ ] **Page Views**: `app_opened`, `practice_session_start`, `web_page_view`
- [ ] **Verse Events**:
    - `verse_displayed` for Col 1:17
    - `verse_correct` for Col 1:17 correct answer
    - `verse_displayed` for Gal 5:1
    - `verse_nearly_correct` for Gal 5:2 nearly correct answer
- [ ] **User Properties**: platform: "web", environment details
- [ ] **Session Recording**: Web session with user interactions

### Test Credentials & Expected Flow

**Login**: `njwandroid@gmail.com` / `[your password]`  
**Verse 1**: "He is before all things..." → Answer: `Col 1:17` → Green ✅  
**Verse 2**: "It is for freedom..." → Answer: `Gal 5:2` → Orange ⚠️ (Expected: `Gal 5:1`)

### Troubleshooting Links

- PostHog Flutter
  SDK: [https://posthog.com/docs/libraries/flutter](https://posthog.com/docs/libraries/flutter)
- PostHog Events Debugger: Check "Live Events" in your PostHog project
- Analytics Implementation: `lib/src/common/services/analytics_service.dart`

## AI-Assisted Development Log

- [ ] Included a link to the AI Prompts Log file for this branch/task.
    - Link: [ e.g., MEM-XXX_YYYY-MM-DD_ai_prompts_log.md ]

## AI Review Checklist (Suggested)

*This section encourages leveraging different AI models for review.*

- [ ] **Primary AI (e.g., Claude) Output Review**:
    - [ ] Reviewed the code generated/modified by the primary AI.
    - [ ] Verified logic and adherence to project standards.
- [ ] **Secondary AI (e.g., Gemini) Review**:
    - [ ] Tasked a secondary AI (like Gemini 2.5 Pro) to review the changes made by the primary AI
      and the developer.
    - [ ] Attached or linked the secondary AI's review document (e.g., `gemini_review.md`).
    - Link/Attachment: [ Link to review doc ]
    - [ ] Addressed key concerns raised in the secondary AI's review.
- [ ] **Manual Code Review**:
    - [ ] Performed a final manual review of all changes.

## PWA Testing Checklist (If Applicable)

*Include this section if changes might affect the PWA.*

- [ ] **Netlify Preview Deployment**:
    - [ ] Verified the Netlify preview deployment built successfully.
    - [ ] Accessed the preview URL: [ Paste Preview URL here ]
- [ ] **Installation Test**:
    - [ ] Tested "Add to Home Screen" / "Install App" functionality on the preview URL.
    - [ ] Tested on iOS (Safari).
    - [ ] Tested on Android (Chrome).
    - [ ] Tested on Desktop (Chrome/Edge).
- [ ] **Offline Functionality Test**:
    - [ ] Loaded key app sections in the installed PWA preview.
    - [ ] Enabled airplane mode.
    - [ ] Verified essential offline content/functionality works as expected.
- [ ] **Manifest & Service Worker**:
    - [ ] Checked browser developer tools for correct manifest loading.
    - [ ] Verified the service worker is active and controlling the page.

## Standard Testing Checklist

- [ ] Unit tests pass.
- [ ] Widget tests pass.
- [ ] Integration tests pass (if applicable).
- [ ] Pre-commit checks pass (`./scripts/check_before_commit.sh`).
- [ ] Addressed relevant CodeRabbit / Linter suggestions.
- [ ] Documentation updated (README, CONTRIBUTING, feature-specific docs).

## Outstanding Issues / Next Steps

[ List any known issues, unresolved problems, or required follow-up actions ]
