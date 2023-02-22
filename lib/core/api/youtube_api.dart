import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:yotifiy/config.dart';
import 'package:yotifiy/core/api/cache/search_cache.dart';
import 'package:yotifiy/core/logger.dart';
import 'package:yotifiy/playlist/playlist_model.dart';
import 'package:yotifiy/user/user_info.dart';

class YFYoutubeApi with Logger {
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
      'https://www.googleapis.com/youtube/v3/playlists';
  final String _endpointPlaylistItems =
      'https://www.googleapis.com/youtube/v3/playlistItems';
  final String _endpointSearch = 'https://www.googleapis.com/youtube/v3/search';
  final String _endpointUserInfo =
      'https://www.googleapis.com/oauth2/v1/userinfo';

  YFYoutubeApi()
      : _clientId = Config.googleClientId(),
        _clientSecret = Config.googleClientSecret();

  OAuth2Helper get _authHelper {
    var helper = OAuth2Helper(
      GoogleOAuth2Client(
        redirectUri: _redirectUri,
        customUriScheme: _uriScheme,
      ),
      grantType: OAuth2Helper.authorizationCode,
      clientId: _clientId,
      clientSecret: _clientSecret,
      scopes: _scopes,
    );

    return helper;
  }

  Future<List<YFPlaylist>> fetchPlaylists() async {
    var res = await _authHelper.get(
      '$_endpointPlaylists?part=snippet&maxResults=50&mine=true',
    );
    var playlistsJson = jsonDecode(res.body)['items'] ?? [];

    List<YFPlaylist> playlists = [];

    for (var item in playlistsJson) {
      if (item['kind'] != 'youtube#playlist') {
        continue;
      }

      final playlist = await _convertJsonToPlaylist(item);
      playlists.add(playlist);
    }

    return playlists;
  }

  Future<List<YFMediaItem>> fetchPlaylistItems(String playlistId) async {
    List<YFMediaItem> mediaItems = <YFMediaItem>[];

    var res = await _authHelper.get(
      '$_endpointPlaylistItems?part=snippet&maxResults=50&playlistId=$playlistId',
    );

    var mediaItemsJson = jsonDecode(res.body)['items'] ?? [];

    for (var item in mediaItemsJson) {
      if (item['kind'] != 'youtube#playlistItem') {
        continue;
      }

      mediaItems.add(_convertJsonToMediaItem(item));
    }

    return mediaItems;
  }

  Future<List<YFMediaItem>> search(String query) async {
    var cachedSearchResult = await SearchCache.getAsync(query);

    if (cachedSearchResult.isNotEmpty) {
      log('Loaded cached search result for: $query');

      return cachedSearchResult;
    }

    List<YFMediaItem> results = <YFMediaItem>[];

    var res = await _authHelper
        .get('$_endpointSearch?part=snippet&safeSearch=none&q=$query');

    if (res.statusCode != 200) {
      // TODO: extract to method and reuse
      String errorMessage = jsonDecode(res.body)['error']?['message'] ?? '';
      throw Exception('Could not fetch results. (Error: $errorMessage)');
    }
    var items = jsonDecode(res.body)['items'] ?? [];

    for (var item in items) {
      if (item['kind'] != 'youtube#searchResult') {
        continue;
      }

      results.add(_convertJsonToMediaItem(item));
    }

    SearchCache.storeAsync(query, results);

    return results;
  }

  Future<void> createPlaylist(YFPlaylist youtubePlaylist) async {
    var res = await _authHelper.post('$_endpointPlaylists?part=snippet',
        body: jsonEncode({
          "snippet": {
            "title": youtubePlaylist.name,
            "description": youtubePlaylist.description
          }
        }));

    var playlistData = jsonDecode(res.body);
    var playlistId = playlistData['id'] ?? '';

    if (playlistId == '') {
      return;
    }

    print("Creating playlist $playlistId");
    for (var item in youtubePlaylist.mediaItems) {
      await _insertVideoItemIntoPlaylist(playlistId, item.id);
      print("Added video ${item.id}");
    }
  }

  Future<void> _insertVideoItemIntoPlaylist(playlistId, String videoId) async {
    await _authHelper.post('$_endpointPlaylistItems?part=snippet',
        body: jsonEncode({
          "snippet": {
            "playlistId": playlistId,
            "resourceId": {
              "videoId": videoId,
              "kind": "youtube#video",
            }
          }
        }));
  }

  Future<YFUserInfo> fetchUserInfo() async {
    var res = await _authHelper.get('$_endpointUserInfo?alt=json');

    var data = jsonDecode(res.body);

    return YFUserInfo(
      firstname: data['given_name'] ?? '',
      lastname: data['family_name'] ?? '',
      picture: data['picture'] ?? '',
      locale: data['locale'] ?? '',
    );
  }

  Future<void> login() async {
    await _authHelper.getToken();
  }

  Future<void> logout() async {
    await _authHelper.removeAllTokens();
  }

  Future<YFPlaylist> _convertJsonToPlaylist(dynamic playlistJson) async {
    var id = playlistJson['id'] ?? '';

    List<YFMediaItem> mediaItems = await fetchPlaylistItems(id);

    return YFPlaylist(
      PlaylistType.youtube,
      id: id,
      name: playlistJson['snippet']?['title'] ?? '',
      description: playlistJson['snippet']?['description'] ?? '',
      thumbnailURL:
          playlistJson['snippet']?['thumbnails']?['default']?['url'] ?? '',
      playlistURL:
          (id != '') ? 'https://music.youtube.com/playlist?list=$id' : '',
      mediaItems: mediaItems,
    );
  }

  YFMediaItem _convertJsonToMediaItem(json) {
    dynamic itemSnippet = json['snippet'];

    var playlistId = itemSnippet?['playlistId'] ?? '';
    var mediaItemId = itemSnippet?['resourceId']?['videoId'] ?? '';

    if (mediaItemId == '') {
      mediaItemId = json['id']?['videoId'] ?? '';
    }

    final publishDate = itemSnippet?['publishedAt'] ?? '';

    YFMediaItem mediaItem = YFMediaItem(
      id: mediaItemId,
      name: itemSnippet?['title'] ?? '',
      description: itemSnippet?['description'] ?? '',
      mediaImageURL: itemSnippet?['thumbnails']?['default']?['url'] ?? '',
      mediaURL: (mediaItemId != '')
          ? 'https://music.youtube.com/watch?v=$mediaItemId&list=$playlistId'
          : '',
      publishDate: _formatDate(publishDate),
      owner: itemSnippet?['videoOwnerChannelTitle'] ?? '',
    );

    return mediaItem;
  }

  String _formatDate(String? date) {
    if (date == null) {
      return '-';
    }

    DateTime dateTime = DateTime.parse(date);

    return DateFormat('dd. MMMM yyyy').format(dateTime);
  }
}
