import 'package:yotifiy/youtube_auth/youtube_api.dart';
import 'package:yotifiy/core/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'youtube_auth_cubit.g.dart';

@CopyWith()
class YFYoutubeAuthState {
  final String? data;
  final bool isLoading;
  final dynamic error;
  final bool isAuthenticated;

  bool get hasError => error != null;

  YFYoutubeAuthState({
    this.data,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });
}

class YFAuthCubit extends Cubit<YFYoutubeAuthState> with Logger {
  final YFYoutubeApi _youtubeApi;

  YFAuthCubit(this._youtubeApi) : super(YFYoutubeAuthState());

  Future<void> login() async {
    try {
      emit(state.copyWith(isLoading: true));
      await _youtubeApi.login();
      emit(state.copyWith(isAuthenticated: true, isLoading: false));
    } catch (e, stack) {
      emit(state.copyWith(isAuthenticated: false, isLoading: false));
      logError(e, stack);
    }
  }
}
