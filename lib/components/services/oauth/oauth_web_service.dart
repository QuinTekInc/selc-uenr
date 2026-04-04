

import 'dart:async';
import 'dart:html' as html;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:selc_uenr/components/services/oauth/oauth_credentials.dart';
import 'package:selc_uenr/components/services/oauth/oauth_service.dart';

class OAuthWebService extends OAuthService {

  @override
  Future<Map<String, dynamic>> performSignIn(AuthCredentials credentials) async {
    // 1. Create the Grant
    var grant = oauth2.AuthorizationCodeGrant(
      credentials.clientId,
      credentials.authorizationEndpoint,
      credentials.tokenEndpoint,
      secret: credentials.clientSecret,
    );

    var redirectURI = Uri.parse(credentials.redirectUrl);

    // 2. Generate the Authorization URL
    // Included scopes if they are provided in your credentials object
    var authUrl = grant.getAuthorizationUrl(redirectURI, scopes: credentials.scopes);

    // 3. Open Popup and wait for the redirect URL back
    final responseUrl = await _listenForRedirect(authUrl);

    // 4. Exchange the code for a Client
    final client = await grant.handleAuthorizationResponse(responseUrl.queryParameters);

    //retrieve the access token
    final String accessToken = client.credentials.accessToken;

    return fetchUserInfo(accessToken);
  }

  /// Opens a popup window and listens for a message from auth.html
  Future<Uri> _listenForRedirect(Uri authUrl) {
    final completer = Completer<Uri>();

    final popup = html.window.open(
      authUrl.toString(),
      'student_authentication',
      'width=600,height=800',
    );

    // Listen for the message from auth.html
    late StreamSubscription sub;
    sub = html.window.onMessage.listen((event) {
      final data = event.data.toString();

      // Only proceed if the message actually contains our OAuth code
      if (data.contains('code=') || data.contains("access_code=")) {

        print("Flutter received the code from popup!");

        sub.cancel();
        completer.complete(Uri.parse(data));
      }
    });

    // If the user closes the popup manually, reject the future
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (popup.closed == true) {
        timer.cancel();
        if (!completer.isCompleted) {
          completer.completeError("User closed the window");
        }
      }
    });

    return completer.future;
  }

}


OAuthWebService createService() => OAuthWebService();

