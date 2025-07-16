import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/utils/app_logger.dart';

/// Provider to check if user is logged in
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.isLoggedIn();
});

/// Provider for accessing the access token across the app
final accessTokenProvider = Provider<String>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.token?.accessToken ?? '';
});

/// Provider for accessing the formatted bearer token for Authorization header
final bearerTokenProvider = Provider<String>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState.token?.accessToken == null || authState.token!.accessToken.isEmpty) {
    return '';
  }
  return '${authState.token!.tokenType} ${authState.token!.accessToken}';
});

/// Provider for the client id
final clientIdProvider = Provider<String>((ref) {
  return ref.watch(bootstrapProvider).clientId;
});

/// Provider for the AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final clientId = ref.watch(clientIdProvider);
  if (clientId.isEmpty || clientId == 'debug') {
    return MockAuthService();
  }
  return AuthService();
});

/// Authentication state provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final clientId = ref.watch(clientIdProvider);
  final analyticsService = ref.watch(analyticsServiceProvider);
  return AuthNotifier(authService, clientId, analyticsService);
});

/// Authentication state
class AuthState {
  /// Creates an authentication state
  const AuthState({this.isAuthenticated = false, this.isLoading = false, this.token, this.error});

  final bool isAuthenticated;
  final bool isLoading;
  final AuthToken? token;
  final String? error;

  AuthState copyWith({bool? isAuthenticated, bool? isLoading, AuthToken? token, String? error}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      error: error,
    );
  }
}

/// Authentication state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService, this._clientId, this._analyticsService)
    : super(const AuthState()) {
    _init();
  }

  final AuthService _authService;
  final String _clientId;
  final AnalyticsService _analyticsService;

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      final token = await _authService.getToken();
      state = state.copyWith(isAuthenticated: true, isLoading: false, token: token);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> login(String username, String password) async {
    try {
      state = state.copyWith(isLoading: true);

      AppLogger.i('Attempting login with client ID present: ${_clientId.isNotEmpty}');
      final token = await _authService.login(username, password, _clientId);

      // Log token information (non-sensitive parts)
      if (token.accessToken.isNotEmpty) {
        // Only log in debug mode
        if (kDebugMode) {
          AppLogger.d('Successfully authenticated');
        }
        AppLogger.i('Successfully authenticated');

        // Track successful login
        await _analyticsService.trackLogin(username);
      }

      state = state.copyWith(isAuthenticated: true, isLoading: false, token: token);
    } catch (e) {
      AppLogger.e('Login failed', e);

      // Track login failure
      await _analyticsService.trackLoginFailure(username, e.toString());

      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      await _authService.logout();

      // Track logout
      await _analyticsService.trackLogout();

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
