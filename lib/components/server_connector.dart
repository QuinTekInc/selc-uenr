

import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:selc_uenr/components/preferences_util.dart';
import 'package:selc_uenr/components/services/secure_stoage_service.dart';

const String base_url = 'http://127.0.0.1:8000';
//const String base_url = 'https://selc-backend.onrender.com';


String concat(String other){
  return '$base_url/std-api/$other';
}


Future<Map<String, String>>  getDefaultHeaders() async {

  Map<String, String> headers = {
    'Content-Type': 'application/json'
  };

  String? authToken = await SecureStorageService.getAuthToken();

  if(authToken != null){
    headers['Authorization'] = authToken;
  }


  return headers;
}


Future<http.Response> getRequest({required String endPoint, dynamic body}) async {

  final url = Uri.parse(concat(endPoint));

  Map<String, String> headers = await getDefaultHeaders();

  final response = await http.get(url, headers: headers);

  return response;
}



Future<http.Response> postRequest({required String endpoint, required Object body}) async {
  final url = Uri.parse(concat(endpoint));

  //adding authorization to it. 
  Map<String, String> headers = await getDefaultHeaders();

  return await http.post(
    url,
    headers: headers,
    body: body
  );
}


