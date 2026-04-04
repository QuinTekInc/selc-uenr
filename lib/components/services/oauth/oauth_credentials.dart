

import 'dart:io';

import 'package:flutter/foundation.dart';


//this class would need to be overridden
abstract class AuthCredentials{
  String get clientId;
  String? get clientSecret;
  Uri get authorizationEndpoint;
  Uri get tokenEndpoint;
  List<String> get scopes;
  String get redirectUrl;
  String get issuer;
}




//the facebook oauth credentials will be implemented once
//the facebook oauth has been setup.
class UenrAuthCredentials extends AuthCredentials{

  @override
  // TODO: implement issuer
  String get issuer => throw UnimplementedError();

  @override
  // TODO: implement authorizationEndpoint
  Uri get authorizationEndpoint => throw UnimplementedError();

  @override
  // TODO: implement clientId
  String get clientId => throw UnimplementedError();

  @override
  // TODO: implement clientSecret
  String? get clientSecret => throw UnimplementedError();

  @override
  // TODO: implement redirectUrl
  String get redirectUrl => throw UnimplementedError();

  @override
  // TODO: implement scopes
  List<String> get scopes => throw UnimplementedError();

  @override
  // TODO: implement tokenEndpoint
  Uri get tokenEndpoint => throw UnimplementedError();

}

