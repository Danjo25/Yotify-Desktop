import 'package:yotifiy/auth/auth_api.dart';
import 'package:yotifiy/core/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YFAuthState {
  final String? data;
  final bool isLoading;
  final dynamic error;
  final bool isAuthenticated;

  bool get hasError => error != null;

  YFAuthState({
    this.data,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });
}

class YFAuthCubit extends Cubit<YFAuthState> with Logger {
  final YFAuthApi _api;

  YFAuthCubit(this._api) : super(YFAuthState());

  Future<void> loginSpotify(String username, String password) async {
    try {
      print('LoginSpotify');
    } catch (e, stack) {
      logError(e, stack);
    }
  }
}
