// Mocks generated by Mockito 5.4.5 from annotations
// in memverse/test/auth_providers_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:memverse/src/features/auth/data/auth_service.dart' as _i3;
import 'package:memverse/src/features/auth/domain/auth_token.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAuthToken_0 extends _i1.SmartFake implements _i2.AuthToken {
  _FakeAuthToken_0(Object parent, Invocation parentInvocation) : super(parent, parentInvocation);
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i3.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.AuthToken> login(String? username, String? password, String? clientId) =>
      (super.noSuchMethod(
            Invocation.method(#login, [username, password, clientId]),
            returnValue: _i4.Future<_i2.AuthToken>.value(
              _FakeAuthToken_0(this, Invocation.method(#login, [username, password, clientId])),
            ),
          )
          as _i4.Future<_i2.AuthToken>);

  @override
  _i4.Future<void> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<bool> isLoggedIn() =>
      (super.noSuchMethod(
            Invocation.method(#isLoggedIn, []),
            returnValue: _i4.Future<bool>.value(false),
          )
          as _i4.Future<bool>);

  @override
  _i4.Future<_i2.AuthToken?> getToken() =>
      (super.noSuchMethod(
            Invocation.method(#getToken, []),
            returnValue: _i4.Future<_i2.AuthToken?>.value(),
          )
          as _i4.Future<_i2.AuthToken?>);

  @override
  _i4.Future<void> saveToken(_i2.AuthToken? token) =>
      (super.noSuchMethod(
            Invocation.method(#saveToken, [token]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);
}
