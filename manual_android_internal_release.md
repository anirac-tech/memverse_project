# Android Internal Release Process (Staging Flavor)

This document outlines the steps to create and distribute an internal **staging** Android release
for the Memverse Flutter app using Firebase App Distribution. The staging flavor typically connects
to production backend services.

## Prerequisites

* Firebase project set up with App Distribution enabled.
* Firebase CLI installed and configured (optional, for CLI distribution).
* Git installed and configured.
* Flutter SDK installed and configured.
* Android development environment set up.
* **`MEMVERSE_CLIENT_ID` environment variable set:** The build requires the client ID for
  authentication. Ensure this variable is set in your terminal session before running the release
  script. Refer to `setup.md` for instructions.
* Tester emails added to Firebase App Distribution or Invite Links set up (see Managing Testers
  section).

## 1. Automated Release Creation (Recommended)

Use the provided script to automate version bumping, tagging, and building the **staging** flavor.

1. **Ensure Clean State & Env Var:**

* Make sure your current branch is up-to-date and you have no uncommitted changes (`git status`).
* Verify the `MEMVERSE_CLIENT_ID` is set: `echo $MEMVERSE_CLIENT_ID` (should display your ID).

2. **Run the Script:** Execute the release script from the project root.