

import 'dart:io';

import 'package:selc_uenr/components/services/oauth/oauth_credentials.dart';
import 'package:selc_uenr/components/services/oauth/oauth_service.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth2/oauth2.dart' as oauth2;


class OAuthServiceIO extends OAuthService {
  
  @override
  Future<Map<String, dynamic>> performSignIn(AuthCredentials credentials) async {

    String accessToken;

    if(Platform.isAndroid || Platform.isIOS){
      accessToken = await _mobileSignIn(credentials);
    }else{
      accessToken = await _desktopSignIn(credentials);
    }

    Map<String, dynamic> userInfoMap = await fetchUserInfo(accessToken);

    return userInfoMap;
  }


  //desktop process to receive the access code.
  Future<String> _desktopSignIn(AuthCredentials credentials) async {

    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    final Uri redirectUri = Uri.parse(credentials.redirectUrl);

    //code grant uri builder class.
    var grant = oauth2.AuthorizationCodeGrant(
        credentials.clientId,
        credentials.authorizationEndpoint,
        credentials.tokenEndpoint,
        secret: credentials.clientSecret
    );

    //get the build the authorization url with from the grant object
    //but then we specify the redirect uri and the scopes.
    var authUrl = grant.getAuthorizationUrl(redirectUri, scopes: credentials.scopes);

    //launch the oauth flow.
    await launchUrl(authUrl);

    // 4. Wait for the redirect request
    final request = await server.first;
    final params = request.uri.queryParameters;


    // Send a simple response to the browser
    request.response
      ..statusCode = 200
      ..headers.contentType = ContentType.html
      ..write('<h3>Login successful! You can close this tab/Window</h3>')
      ..close();


    await server.close();


    //get the authorization key from form response sent to our desktop server.
    if (params.containsKey('code')) {

      final client = await grant.handleAuthorizationResponse(params);
      final accessToken = client.credentials.accessToken;

      return accessToken;

    } else {
      throw Exception('No authorization code received');
    }

  }

// ... inside OauthServiceIO class

  Future<String> _mobileSignIn(AuthCredentials credentials) async {

    FlutterAppAuth flutterAppAuth = FlutterAppAuth();

    try {
      final AuthorizationTokenResponse result = await flutterAppAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          credentials.clientId,
          credentials.redirectUrl,
          clientSecret: credentials.clientSecret,
          issuer: credentials.issuer,
          scopes: credentials.scopes,
          allowInsecureConnections: true,
        ),
      );


      if (result.accessToken == null && result.refreshToken == null) {
        throw Exception('Could not obtain token from server');
      }

      //save the token the flutter secure storage.
      return result.accessToken ?? '';

    } on Exception catch (_) {
      rethrow;
    }
  }
}


OAuthServiceIO createService() => OAuthServiceIO();