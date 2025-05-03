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