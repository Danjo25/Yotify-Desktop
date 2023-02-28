import 'package:yotifiy/core/api/spotify_api.dart';
import 'package:yotifiy/core/api/youtube_api.dart';
import 'package:yotifiy/core/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:yotifiy/user/user_info.dart';

part 'youtube_auth_cubit.g.dart';

@CopyWith()
class YFYoutubeAuthState {
  final bool isLoading;
  final dynamic error;
  final bool isAuthenticated;
  final YFUserInfo? userInfo;

  bool get hasError => error != null;
  YFUserInfo? get user => userInfo;

  YFYoutubeAuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.userInfo,
  });
}

class YFAuthCubit extends Cubit<YFYoutubeAuthState> with Logger {
  final YFYoutubeApi _youtubeApi;
  final YFSpotifyApi _spotifyApi;

  YFAuthCubit(this._youtubeApi, this._spotifyApi) : super(YFYoutubeAuthState());

  Future<void> login() async {
    try {
      emit(state.copyWith(isLoading: true));

      await _youtubeApi.login();
      YFUserInfo user = await _youtubeApi.fetchUserInfo();

      emit(state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userInfo: user,
      ));
    } catch (e, stack) {
      emit(state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e,
      ));

      logError(e, stack);
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(isLoading: true));

      await _spotifyApi.logout();
      await _youtubeApi.logout();

      emit(state.copyWith(
        isAuthenticated: false,
        isLoading: false,
      ));
    } catch (e, stack) {
      emit(state.copyWith(
        isLoading: false,
        error: e,
      ));

      logError(e, stack);
    }
  }
}
