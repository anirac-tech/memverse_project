import 'package:json_annotation/json_annotation.dart';

part 'password_token_request.g.dart';

@JsonSerializable()
class PasswordTokenRequest {
  PasswordTokenRequest({
    required this.username,
    required this.password,
    required this.clientId,
    this.grantType = 'password',
  });

  factory PasswordTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordTokenRequestFromJson(json);

  @JsonKey(name: 'grant_type')
  final String grantType;

  final String username;
  final String password;

  @JsonKey(name: 'client_id')
  final String clientId;

  Map<String, dynamic> toJson() => _$PasswordTokenRequestToJson(this);
}
