import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/settings/presentation/analytics_provider.dart';
import 'package:memverse/src/features/settings/presentation/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Theme Settings
          const _SettingsHeader(title: 'Appearance'),
          _ThemeModeSwitch(),

          // Account Settings
          const _SettingsHeader(title: 'Account'),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),

          // Daily Reminder (behind feature flag)
          const _SettingsHeader(title: 'Notifications'),
          // TODO: Implement Daily Reminder with feature flag

          // Analytics
          const _SettingsHeader(title: 'Data & Privacy'),
          _AnalyticsToggle(),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ThemeModeSwitch extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: themeMode == ThemeMode.dark,
      onChanged: (bool value) {
        ref.read(themeModeProvider.notifier).state = value ? ThemeMode.dark : ThemeMode.light;
      },
      secondary: const Icon(Icons.dark_mode),
    );
  }
}

class _AnalyticsToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(analyticsEnabledProvider);

    return SwitchListTile(
      title: const Text('Share Usage Analytics'),
      value: isEnabled,
      onChanged: (bool value) {
        // Update the analytics state
        ref.read(analyticsEnabledProvider.notifier).state = value;
        // Note: Posthog opt-in/opt-out would be handled here if needed
      },
      secondary: const Icon(Icons.analytics),
    );
  }
}
