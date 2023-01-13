import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yotifiy/core/logger.dart';
import 'package:yotifiy/youtube_auth/youtube_api.dart';

part 'playlist_cubit.g.dart';

@CopyWith()
class YFPlaylistState {
  final List<String> data;
  final bool isLoading;
  final dynamic error;

  bool get hasError => error != null;

  YFPlaylistState({
    this.data = const [],
    this.isLoading = false,
    this.error,
  });
}

class YFPlaylistCubit extends Cubit<YFPlaylistState> with Logger {
  final YFYoutubeApi _youtubeApi;

  YFPlaylistCubit(this._youtubeApi) : super(YFPlaylistState());

  Future<void> getYoutubePlaylists() async {
    emit(state.copyWith(isLoading: true));
    try {
      final r = _youtubeApi.fetchPlaylists();
      emit(state.copyWith(data: r as List<String>, isLoading: false));
    } catch (e, stack) {
      emit(state.copyWith(isLoading: false));
      logError(e, stack);
    }
  }
}
