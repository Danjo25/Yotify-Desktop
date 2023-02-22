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

  Future<YFPlaylist> _convertSpotifyPlaylistToYoutube(
      YFPlaylist spotifyPlaylist) async {
    List<YFMediaItem> youtubePlaylistItems = [];
    for (var item in spotifyPlaylist.mediaItems) {
      List<YFMediaItem> searchResults =
          await _youtubeApi.search('${item.name} - ${item.owner}');
      if (searchResults.isNotEmpty) {
        YFMediaItem mediaItem = searchResults.first;
        youtubePlaylistItems.add(mediaItem);
      }
    }

    return YFPlaylist(
      PlaylistType.youtube,
      name: spotifyPlaylist.name,
      description: spotifyPlaylist.description,
      mediaItems: youtubePlaylistItems,
    );
  }

  Future<void> import(YFPlaylist playlist) async {
    if (playlist.playlistType == PlaylistType.spotify) {
      playlist = await _convertSpotifyPlaylistToYoutube(playlist);
    }

    await _youtubeApi.createPlaylist(playlist);
  }
}
