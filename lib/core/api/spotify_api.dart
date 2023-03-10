import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:yotifiy/config.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

class YFSpotifyApi {
  final _redirectUri = 'http://localhost:42070/callback';
  final _uriScheme = 'http://localhost:42070';
  final _scopes = ['playlist-read-private'];
  final _endpointPlaylist = 'https://api.spotify.com/v1/playlists/';
  final String _clientId;
  final String _clientSecret;

  YFSpotifyApi()
      : _clientId = Config.spotifyClientId(),
        _clientSecret = Config.spotifyClientSecret();

  Future<void> logout() async {
    await _authHelper.removeAllTokens();
  }

  Future<YFPlaylist> fetchPlaylist(String playlistId) async {
    var res = await _authHelper.get(_endpointPlaylist + playlistId);
    var data = jsonDecode(res.body); // TODO: throw exception if invalid status

    List<YFMediaItem> mediaItems = await _fetchPlaylistItems(playlistId);

    YFPlaylist playlist = YFPlaylist(
      PlaylistType.spotify,
      id: data['id'] ?? '',
      playlistURL: data['external_urls']?['spotify'] ?? '',
      thumbnailURL: data['images']?[0]?['url'] ?? '',
      description: data['description'] ?? '',
      name: data['name'] ?? '',
      mediaItems: mediaItems,
    );

    return playlist;
  }

  Future<List<YFMediaItem>> _fetchPlaylistItems(String playlistId) async {
    List<YFMediaItem> mediaItems = <YFMediaItem>[];

    var res = await _authHelper.get('$_endpointPlaylist$playlistId/tracks');
    var data = jsonDecode(res.body); // TODO: throw exception if invalid status
    var items = data['items'] ?? [];

    for (var item in items) {
      List artists = item['track']?['artists'] ?? [];
      Iterable<String> artistNames =
          artists.map((artist) => artist['name'] ?? '');

      final publishDate = item['track']?['album']?['release_date'] ?? '';

      YFMediaItem mediaItem = YFMediaItem(
        id: item['track']?['id'] ?? '',
        name: item['track']?['name'] ?? '',
        mediaURL: item['track']?['external_urls']?['spotify'] ?? '',
        mediaImageURL: item['track']?['album']?['images']?[0]?['url'] ?? '',
        owner: artistNames.join(', '),
        publishDate: _formatDate(publishDate),
      );

      mediaItems.add(mediaItem);
    }

    return mediaItems;
  }

  OAuth2Helper get _authHelper {
    var helper = OAuth2Helper(
      SpotifyOAuth2Client(
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

  String _formatDate(String? date) {
    if (date == null) {
      return '-';
    }

    DateTime dateTime = DateTime.parse(date);

    return DateFormat('dd. MMMM yyyy').format(dateTime);
  }
}
