import 'package:flutter/cupertino.dart';
import 'package:yotifiy/core/api/spotify_api.dart';
import 'package:yotifiy/core/api/youtube_api.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

class YFPlaylistImporter {
  final YFSpotifyApi _spotifyApi;
  final YFYoutubeApi _youtubeApi;

  YFPlaylistImporter()
      : _spotifyApi = YFSpotifyApi(),
        _youtubeApi = YFYoutubeApi();

  Future<List<YFMediaItem>> createYoutubePlaylistFromSpotify(
      String spotifyId) async {
    YFPlaylist spotifyPlaylist = await _spotifyApi.fetchPlaylist(spotifyId);

    List<YFMediaItem> youtubePlaylistItems = [];
    for (var item in spotifyPlaylist.mediaItems) {
      List<YFMediaItem> searchResults =
          await _youtubeApi.search('${item.name} - ${item.owner}');
      YFMediaItem mediaItem = searchResults.first;
      youtubePlaylistItems.add(mediaItem);
    }

    return youtubePlaylistItems;
  }
}
