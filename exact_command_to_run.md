# Exact Command to Run

The following command corrects the environment variable references and ensures all required keys are
defined.

Changes made:

1. Changed `$MEMVERSE_API_KEY` to `$MEMVERSE_CLIENT_API_KEY` (matching the `setup.md` instructions).
2. Added `CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY` because `user_repository_provider.dart` requires
   `CLIENT_API_KEY`, while `auth_service.dart` requires `MEMVERSE_CLIENT_API_KEY`.
3. Kept `AUTOSIGNIN=false` as requested.

# Note: in Intellij you can press the green triangle to run the below command in terminal and	806799 it should work

```bash
flutter run \
  --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID \
  --dart-define=MEMVERSE_CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY \
  --dart-define=CLIENT_API_KEY=$MEMVERSE_CLIENT_API_KEY \
  --dart-define=POSTHOG_MEMVERSE_API_KEY=$POSTHOG_MEMVERSE_API_KEY \
  --dart-define=AUTOSIGNIN=false \
  --flavor development \
  --target lib/main_development.dart
```
