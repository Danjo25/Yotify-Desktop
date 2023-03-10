import 'package:json_annotation/json_annotation.dart';

part 'playlist_model.g.dart';

@JsonSerializable()
class YFMediaItem {
  final String id;
  final String name;
  final String description;
  final String mediaImageURL;
  final String mediaURL;
  final String owner;
  final String publishDate;

  YFMediaItem({
    this.id = '',
    this.name = '',
    this.description = '',
    this.mediaImageURL = '',
    this.mediaURL = '',
    this.owner = '',
    this.publishDate = '',
  });

  factory YFMediaItem.fromJson(Map<String, dynamic> json) =>
      _$YFMediaItemFromJson(json);

  Map<String, dynamic> toJson() => _$YFMediaItemToJson(this);
}

@JsonSerializable()
class YFPlaylist {
  final String id;
  final String name;
  final String description;
  final String playlistURL;
  final String thumbnailURL;
  final List<YFMediaItem> mediaItems;
  final PlaylistType playlistType;

  YFPlaylist(
    this.playlistType, {
    this.id = '',
    this.name = '',
    this.description = '',
    this.playlistURL = '',
    this.thumbnailURL = '',
    this.mediaItems = const [],
  });

  factory YFPlaylist.fromJson(Map<String, dynamic> json) =>
      _$YFPlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$YFPlaylistToJson(this);
}

enum PlaylistType { youtube, spotify }
