// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordTokenRequest _$PasswordTokenRequestFromJson(
  Map<String, dynamic> json,
) => PasswordTokenRequest(
  username: json['username'] as String,
  password: json['password'] as String,
  clientId: json['client_id'] as String,
  grantType: json['grant_type'] as String? ?? 'password',
);

Map<String, dynamic> _$PasswordTokenRequestToJson(
  PasswordTokenRequest instance,
) => <String, dynamic>{
  'grant_type': instance.grantType,
  'username': instance.username,
  'password': instance.password,
  'client_id': instance.clientId,
};
