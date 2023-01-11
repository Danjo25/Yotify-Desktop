import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String clientId() {
    String clientId = dotenv.get('GOOGLE_API_CLIENT_ID', fallback: '');

    if (clientId == '') throw Exception('client_id is not configured!');

    return clientId;
  }

  static String clientSecret() {
    String clientSecret = dotenv.get('GOOGLE_API_CLIENT_SECRET', fallback: '');

    if (clientSecret == '') throw Exception('client_secret is not configured!');

    return clientSecret;
  }
}