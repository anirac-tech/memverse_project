import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to track whether analytics is enabled
/// Default to true (analytics enabled)
final analyticsEnabledProvider = StateProvider<bool>((ref) => true);
