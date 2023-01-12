import 'package:yotifiy/youtube_auth/youtube_api.dart';
import 'package:yotifiy/core/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YFYoutubeAuthState {
  final String? data;
  final bool isLoading;
  final dynamic error;

  bool get hasError => error != null;

  YFYoutubeAuthState({
    this.data,
    this.isLoading = false,
    this.error,
  });
}

class YFAuthCubit extends Cubit<YFYoutubeAuthState> with Logger {
  final YFYoutubeApi _youtubeApi;

  YFAuthCubit(this._youtubeApi) : super(YFYoutubeAuthState());

  Future<void> login() async {
    try {
      await _youtubeApi.fetchToken();
    } catch (e, stack) {
      logError(e, stack);
    }
  }
}
