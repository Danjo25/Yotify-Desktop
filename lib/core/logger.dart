import 'dart:developer' as dev;

import 'package:sentry_flutter/sentry_flutter.dart';

mixin Logger {
  void log(dynamic msg) => dev.log(msg, name: '$runtimeType');

  void logError(dynamic e, dynamic stack) {
    log('$e\n$stack');

    Sentry.captureException(
      e,
      stackTrace: stack,
    ).catchError((e, stack) {
      log('$e\n$stack');
    });
  }
}