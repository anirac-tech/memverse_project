import 'package:dio/dio.dart' hide Headers;
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/features/auth/domain/password_token_request.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/oauth/token')
  @Headers(<String, dynamic>{'Content-Type': 'application/x-www-form-urlencoded'})
  Future<AuthToken> getBearerToken(@Body() PasswordTokenRequest request);
}
