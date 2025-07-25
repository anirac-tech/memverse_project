import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memverse/src/app/view/app.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/ref_quiz/memverse_page.dart';
import 'package:memverse/src/features/verse_text_quiz/widgets/verse_text_quiz_screen.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

// TODO: Make this identical to main_developement
void main() {
  // Detect if running in integration test mode via dart-define
  const isIntegrationTest = bool.fromEnvironment('INTEGRATION_TEST');
  if (isIntegrationTest) {
    // Ensure dummy user mode for integration tests
    AuthService.isDummyUser = true;
  }
  container = ProviderContainer(overrides: []);
  container.observers.add(TalkerRiverpodObserver(talker: container.read(talkerProvider)));
  runApp(const App());
}

// TODO: use and use with TalkerObservere
// see andrea's article
final _router = GoRouter(
  initialLocation: '/verse',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return TabScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(child: _HomeTab()),
        ),
        GoRoute(
          path: '/verse',
          pageBuilder: (context, state) => const NoTransitionPage(child: VerseTextQuizScreen()),
        ),
        GoRoute(
          path: '/ref',
          pageBuilder: (context, state) => const NoTransitionPage(child: MemversePage()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(child: _SettingsTab()),
        ),
      ],
    ),
  ],
);

final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Bottom navigation/tab scaffold using GoRouter and ShellRoute
class TabScaffold extends StatelessWidget {
  const TabScaffold({required this.child, super.key});

  final Widget child;

  static final _tabs = [
    const _TabItem(label: 'Home', icon: Icons.home, location: '/home'),
    const _TabItem(label: 'Review', icon: Icons.menu_book_rounded, location: '/verse'),
    const _TabItem(label: 'Progress', icon: Icons.bar_chart_rounded, location: '/ref'),
    const _TabItem(label: 'Settings', icon: Icons.settings, location: '/settings'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return _tabs.indexWhere((t) => location == t.location) >= 0
        ? _tabs.indexWhere((t) => location == t.location)
        : 1; // Default to Verse/Review tab
  }

  @override
  Widget build(BuildContext context) {
    final currentIdx = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdx,
        onTap: (idx) {
          final loc = _tabs[idx].location;
          if (GoRouterState.of(context).uri.toString() != loc) {
            context.go(loc);
          }
        },
        items: _tabs
            .map((t) => BottomNavigationBarItem(icon: Icon(t.icon), label: t.label))
            .toList(),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.icon, required this.location});

  final String label;
  final IconData icon;
  final String location;
}

// Minimal placeholder widgets for each tab (replace with real screens as needed)
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) => const Center(child: Text('Home'));
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) => const Center(child: Text('Settings'));
}
