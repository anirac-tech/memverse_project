import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/utils/app_logger.dart';

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
  return AuthService();
});

/// Authentication state provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final clientId = ref.watch(clientIdProvider);
  return AuthNotifier(authService, clientId);
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
  AuthNotifier(this._authService, this._clientId) : super(const AuthState()) {
    _init();
  }

  final AuthService _authService;
  final String _clientId;

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

      AppLogger.i(
        'Logging in with username: $username and clientId is non-empty: ${_clientId.isNotEmpty}',
      );
      final token = await _authService.login(username, password, _clientId);

      // Log token information (non-sensitive parts)
      if (token.accessToken.isNotEmpty) {
        debugPrint('TOKEN IS NOT EMPTY - Successfully authenticated');
        // Log additional information about token formatting
        debugPrint(
          'TOKEN FORMAT - Type: ${token.tokenType}, Format for Authorization header: ${token.tokenType} ${token.accessToken}',
        );
        AppLogger.i('Successfully authenticated with token type: ${token.tokenType}');
      }

      state = state.copyWith(isAuthenticated: true, isLoading: false, token: token);
    } catch (e) {
      AppLogger.e('Login failed', e);
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      await _authService.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
