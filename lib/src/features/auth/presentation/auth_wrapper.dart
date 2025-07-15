import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/signed_in/presentation/signed_in_nav_scaffold.dart';

class AuthWrapper extends HookConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (AuthService.isDummyUser) {
      // If autosignin, skip login and show tabs w/mock data
      return const SignedInNavScaffold();
    }
    final isLoggedInAsync = ref.watch(isLoggedInProvider);
    final authState = ref.watch(authStateProvider);

    return isLoggedInAsync.when(
      data: (isLoggedIn) {
        // If loading auth state, show loading indicator
        if (authState.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Show login if not authenticated, otherwise show the app content
        return authState.isAuthenticated ? const SignedInNavScaffold() : const LoginPage();
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text('Error checking authentication status'))),
    );
  }
}
