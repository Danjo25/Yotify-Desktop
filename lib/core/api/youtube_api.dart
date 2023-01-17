import 'dart:convert';

import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:yotifiy/config.dart';
import 'package:yotifiy/playlist/playlist_model.dart';
import 'package:yotifiy/user/user_info.dart';

class YFYoutubeApi {
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
      'https://www.googleapis.com/youtube/v3/playlists?part=snippet&mine=true';
  final String _endpointPlaylistItems =
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet';
  final String _endpointSearch =
      'https://www.googleapis.com/youtube/v3/search?part=snippet&safeSearch=none';
  final String _endpointUserInfo =
      'https://www.googleapis.com/oauth2/v1/userinfo?alt=json';

  YFYoutubeApi()
      : _clientId = Config.googleClientId(),
        _clientSecret = Config.googleClientSecret();

  OAuth2Helper get _authHelper {
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

  Future<List<YFPlaylist>> fetchPlaylists() async {
    var res = await _authHelper.get(_endpointPlaylists);
    var items = jsonDecode(res.body)['items'] ?? [];

    List<YFPlaylist> playlists = <YFPlaylist>[];

    for (var item in items) {
      if (item['kind'] != 'youtube#playlist') {
        continue;
      }

      var id = item['id'] ?? '';

      List<YFMediaItem> mediaItems = await fetchPlaylistItems(id);

      YFPlaylist playlist = YFPlaylist(
        id: id,
        name: item['snippet']?['title'] ?? '',
        description: item['snippet']?['description'] ?? '',
        thumbnailURL: item['snippet']?['thumbnails']?['default']?['url'] ?? '',
        playlistURL:
            (id != '') ? 'https://music.youtube.com/playlist?list=$id' : '',
        mediaItems: mediaItems,
      );

      playlists.add(playlist);
    }

    return playlists;
  }

  Future<List<YFMediaItem>> fetchPlaylistItems(String playlistId) async {
    List<YFMediaItem> mediaItems = <YFMediaItem>[];

    var res =
        await _authHelper.get('$_endpointPlaylistItems&playlistId=$playlistId');

    var items = jsonDecode(res.body)['items'] ?? [];

    for (var item in items) {
      if (item['kind'] != 'youtube#playlistItem') {
        continue;
      }

      mediaItems.add(_buildMediaItem(item));
    }

    return mediaItems;
  }

  Future<List<YFMediaItem>> search(String query) async {
    List<YFMediaItem> results = <YFMediaItem>[];

    var res = await _authHelper.get('$_endpointSearch&q=$query');

    var items = jsonDecode(res.body)['items'] ?? [];

    for (var item in items) {
      if (item['kind'] != 'youtube#searchResult') {
        continue;
      }

      results.add(_buildMediaItem(item));
    }

    return results;
  }

  YFMediaItem _buildMediaItem(item) {
    var playlistId = item['snippet']?['playlistId'] ?? '';
    var id = item['snippet']?['resourceId']?['videoId'] ?? '';

    if (id == '') {
      id = item['id']?['videoId'] ?? '';
    }

    YFMediaItem mediaItem = YFMediaItem(
      id: id,
      name: item['snippet']?['title'] ?? '',
      description: item['snippet']?['description'] ?? '',
      mediaImageURL: item['snippet']?['thumbnails']?['default']?['url'] ?? '',
      mediaURL: (id != '')
          ? 'https://music.youtube.com/watch?v=$id&list=$playlistId'
          : '',
    );

    return mediaItem;
  }

  Future<YFUserInfo> fetchUserInfo() async {
    var res = await _authHelper.get(_endpointUserInfo);

    var data = jsonDecode(res.body);

    return YFUserInfo(
      firstname: data['given_name'] ?? '',
      lastname: data['family_name'] ?? '',
      picture: data['picture'] ?? '',
      locale: data['locale'] ?? '',
    );
  }

  Future<void> login() async {
    AccessTokenResponse? token = await _authHelper.getToken();
    String tokenString = token?.accessToken ?? '';
  }

  Future<void> logout() async {
    await _authHelper.removeAllTokens();
  }

  Future<void> debugToken() async {
    var client = OAuth2Client(
      authorizeUrl: _authUrl,
      tokenUrl: _tokenUrl,
      redirectUri: _redirectUri,
      customUriScheme: _uriScheme,
    );

    var tknResp = await client.getTokenWithAuthCodeFlow(
      clientId: _clientId,
      scopes: _scopes,
      clientSecret: _clientSecret,
    );
  }
}
