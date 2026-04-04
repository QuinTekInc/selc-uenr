
import 'dart:async';
import 'dart:convert';
import 'package:selc_uenr/components/services/oauth/oauth_credentials.dart';


import 'package:selc_uenr/components/services/oauth/oauth_service_stub.dart'
  if(dart.library.io) "oauth_service_io.dart"
  if(dart.library.html) "oauth_web_service.dart";


import 'package:http/http.dart' as http;

abstract class OAuthService {

  //For mobile and Desktop
  Future<Map<String, dynamic>> performSignIn(AuthCredentials credentials);


  // Fetch Google user info
  Future<Map<String, dynamic>> fetchUserInfo(String accessToken) async {

    final response = await http.get(
      Uri.parse('https://www.googleapis.com/oauth2/v3/userinfo'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user info');
    }

    return json.decode(response.body);
  }

}


OAuthService getService() => createService();




