import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Provider for the Talker logging instance
final talkerProvider = Provider<Talker>((ref) {
  return Talker();
});
