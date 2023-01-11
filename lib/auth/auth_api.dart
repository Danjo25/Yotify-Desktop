import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:yotify/services/config.dart';

class YoutubeApi {
  final String _redirectUri = 'http://localhost:42069/callback';
  final String _uriScheme = 'http://localhost:42069';
  final List<String> _scopes = [
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/youtube'
  ];
  final String _authUrl = 'https://accounts.google.com/o/oauth2/v2/auth';
  final String _tokenUrl = 'https://www.googleapis.com/oauth2/v4/token';
  final String _clientId;
  final String _clientSecret;

  final String _endpointPlaylists =
      'https://www.googleapis.com/youtube/v3/playlists?mine=true';

  YoutubeApi()
      : _clientId = Config.clientId(),
        _clientSecret = Config.clientSecret();

  Future<void> fetchPlaylists() async {
    OAuth2Helper helper = getAuthHelper();

    var res = await helper.get(_endpointPlaylists);

    print(res.body);
  }

  OAuth2Helper getAuthHelper() {
    var helper = OAuth2Helper(
      GoogleOAuth2Client(
          redirectUri: _redirectUri, customUriScheme: _uriScheme),
      grantType: OAuth2Helper.authorizationCode,
      clientId: _clientId,
      clientSecret: _clientSecret,
      scopes: _scopes,
    );

    return helper;
  }

  Future<void> debugToken() async {
    var client = OAuth2Client(
        authorizeUrl: _authUrl,
        tokenUrl: _tokenUrl,
        redirectUri: _redirectUri,
        customUriScheme: _uriScheme);

    var tknResp = await client.getTokenWithAuthCodeFlow(
        clientId: _clientId, scopes: _scopes, clientSecret: _clientSecret);

    print(tknResp.httpStatusCode);
    print(tknResp.error);
    print(tknResp.expirationDate);
    print(tknResp.scope);
  }
}