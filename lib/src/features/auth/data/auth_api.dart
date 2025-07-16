import 'package:dio/dio.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/oauth/token')
  @MultiPart()
  Future<AuthToken> loginNative(
    @Part(name: 'grant_type') String grantType,
    @Part(name: 'username') String username,
    @Part(name: 'password') String password,
    @Part(name: 'client_id') String clientId,
    @Part(name: 'client_secret') String? clientSecret,
    @Part(name: 'api_key') String? apiKey,
  );

  @POST('/oauth/token')
  Future<AuthToken> loginWeb(@Body() Map<String, dynamic> data);
}
