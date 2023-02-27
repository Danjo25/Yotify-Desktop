import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yotifiy/core/api/playlist_importer.dart';
import 'package:yotifiy/core/api/spotify_api.dart';
import 'package:yotifiy/core/logger.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

part 'import_playlist_cubit.g.dart';

@CopyWith()
class YFImportPlaylistState {
  final YFPlaylist? data;
  final bool isLoading;
  final dynamic error;

  bool get hasError => error != null;

  YFImportPlaylistState({
    this.data,
    this.isLoading = false,
    this.error,
  });
}

class YFImportPlaylistCubit extends Cubit<YFImportPlaylistState> with Logger {
  final YFSpotifyApi _spotifyApi;
  final YFPlaylistImporter _playlistImporter;

  YFImportPlaylistCubit(this._spotifyApi, this._playlistImporter)
      : super(YFImportPlaylistState());

  Future<void> createPlaylist(String spotifyPlaylistUrl) async {
    emit(state.copyWith(isLoading: true));
    try {
      String playlistId = _parsePlaylistId(spotifyPlaylistUrl);
      emit(state.copyWith(isLoading: false));
      final r = await _spotifyApi.fetchPlaylist(playlistId);

      emit(state.copyWith(data: r, isLoading: false));
    } catch (e, stack) {
      emit(state.copyWith(isLoading: false));
      logError(e, stack);
    }
  }

  String _parsePlaylistId(String spotifyPlaylistUrl) {
    RegExp regex = RegExp(r'spotify.com/playlist/(\w*)\??');
    RegExpMatch? match = regex.firstMatch(spotifyPlaylistUrl);

    if (match == null) {
      throw "Invalid url";
    }

    return match[1] ?? '';
  }

  Future<void> importPlaylist(YFPlaylist playlist) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _playlistImporter.import(playlist);
      emit(state.copyWith(isLoading: false));
    } catch (e, stack) {
      emit(state.copyWith(isLoading: false));
      logError(e, stack);
    }
  }
}
