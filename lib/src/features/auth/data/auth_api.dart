import 'package:dio/dio.dart' hide Headers;
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

/// Memverse OAuth API client
///
/// IMPORTANT ENDPOINT STRUCTURE:
/// - OAuth token endpoint: /oauth/token (at root level, not under /api/v1/)
/// - Other API endpoints: /api/v1/* (versioned paths)
///
/// AUTHENTICATION REQUIREMENTS:
/// - Content-Type: application/x-www-form-urlencoded (not JSON)
/// - Requires both client_id AND client_secret in form data
/// - Uses @FormUrlEncoded with @Field annotations for proper encoding
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  /// Request OAuth access token using password grant flow
  ///
  /// This endpoint expects form-urlencoded data with the following fields:
  /// - grant_type: "password" (OAuth2 password flow)
  /// - username: User's email address
  /// - password: User's password
  /// - client_id: OAuth client identifier
  /// - client_secret: OAuth client secret (required by Memverse API)
  @POST('/oauth/token')
  @FormUrlEncoded()
  Future<AuthToken> getBearerToken(
    @Field('grant_type') String grantType,
    @Field('username') String username,
    @Field('password') String password,
    @Field('client_id') String clientId,
    @Field('client_secret') String clientSecret,
  );
}
