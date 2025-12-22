import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

final analyticsEnabledProvider = StateProvider<bool>(
  (ref) => Posthog().isOptedOut().then((value) => !value),
);
