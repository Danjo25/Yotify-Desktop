import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String googleClientId() {
    String clientId = dotenv.get('GOOGLE_API_CLIENT_ID', fallback: '');

    if (clientId == '') {
      throw Exception('google client_id is not configured!');
    }

    return clientId;
  }

  static String googleClientSecret() {
    String clientSecret = dotenv.get('GOOGLE_API_CLIENT_SECRET', fallback: '');

    if (clientSecret == '') {
      throw Exception('google client_secret is not configured!');
    }

    return clientSecret;
  }

  static String spotifyClientId() {
    String clientId = dotenv.get('SPOTIFY_API_CLIENT_ID', fallback: '');

    if (clientId == '') {
      throw Exception('spotify client_id is not configured!');
    }

    return clientId;
  }

  static String spotifyClientSecret() {
    String clientSecret = dotenv.get('SPOTIFY_API_CLIENT_SECRET', fallback: '');

    if (clientSecret == '') {
      throw Exception('spotify client_secret is not configured!');
    }

    return clientSecret;
  }
}
