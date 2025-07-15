import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/ref_quiz/memverse_page.dart' as ref_quiz;
// import 'package:memverse/src/features/verse/data/verse_repository.dart'; // Removed as it doesn't exist
import 'package:memverse/src/features/verse_text_quiz/widgets/verse_text_quiz_screen.dart';

void main() {
  // Detect if running in integration test mode via dart-define
  const bool isIntegrationTest = bool.fromEnvironment('INTEGRATION_TEST', defaultValue: false);
  if (isIntegrationTest) {
    // Ensure dummy user mode for integration tests
    AuthService.isDummyUser = true;
  }
  runApp(MyApp(isIntegrationTest: isIntegrationTest));
}

class MyApp extends StatelessWidget {
  final bool isIntegrationTest;

  const MyApp({super.key, this.isIntegrationTest = false});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: isIntegrationTest
          ? [
              analyticsServiceProvider.overrideWithValue(NoOpAnalyticsService()),
              // Add additional test-mode providers here once implemented
            ]
          : [],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Memverse Demo',
        theme: ThemeData(primarySwatch: Colors.green),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    );
  }
}

// GoRouter configuration
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
          pageBuilder: (context, state) => const NoTransitionPage(child: ref_quiz.MemversePage()),
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
  final Widget child;

  const TabScaffold({required this.child, super.key});

  // Colors from Figma screenshot
  static const navBg = Color(0xFF80BC00); // Green bar like mockup
  static const navSelected = Color(0xFF618E1B); // Feathered rich
  static const navLabel = Color(0xFF364526); // Text label color (very dark, accessible)
  static const navGray = Color(0xFF767676); // For unselected
  static final _tabs = [
    _TabItem(label: 'Home', icon: Icons.home, location: '/home'),
    _TabItem(label: 'Review', icon: Icons.menu_book_rounded, location: '/verse'),
    _TabItem(label: 'Progress', icon: Icons.bar_chart_rounded, location: '/ref'),
    _TabItem(label: 'Settings', icon: Icons.settings, location: '/settings'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).location;
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
        backgroundColor: navBg,
        selectedItemColor: navSelected,
        // Selected item matches feathered green
        unselectedItemColor: navGray,
        selectedFontSize: 13,
        unselectedFontSize: 12.2,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          color: navLabel,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.04,
          color: navGray,
        ),
        iconSize: 28,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIdx,
        onTap: (idx) {
          final loc = _tabs[idx].location;
          if (GoRouterState.of(context).location != loc) {
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
  final String label;
  final IconData icon;
  final String location;

  const _TabItem({required this.label, required this.icon, required this.location});
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
