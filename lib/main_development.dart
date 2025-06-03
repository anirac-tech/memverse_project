import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/utils/app_logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

bool hasPostHog = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const apiKey = String.fromEnvironment('POSTHOG_MEMVERSE_API_KEY');
  if (apiKey.isEmpty) {
    AppLogger.e('Error: POSTHOG_MEMVERSE_API_KEY environment variable is not set');
  } else {
    if (kDebugMode) {
      AppLogger.d('PostHog API Key: $apiKey');
    }
    final config = PostHogConfig(apiKey);
    config.host = 'https://us.i.posthog.com';
    config.debug = true;
    config.captureApplicationLifecycleEvents = true;

    // check https://posthog.com/docs/session-replay/installation?tab=Flutter
    // for more config and to learn about how we capture sessions on mobile
    // and what to expect
    config.sessionReplay = true;
    // choose whether to mask images or text
    config.sessionReplayConfig.maskAllTexts = false;
    config.sessionReplayConfig.maskAllImages = false;

    // Setup PostHog with the given Context and Config
    await Posthog().setup(config);
    hasPostHog = true;
  }

  bootstrap(() => const App());
}
