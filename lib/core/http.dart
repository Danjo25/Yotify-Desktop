import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yotifiy/core/api_exception.dart';
import 'package:yotifiy/core/logger.dart';

class YFHttpClient with Logger {
  String _apiUrl = '';
  String token = '';

  final _client = SentryHttpClient(client: http.Client(), networkTracing: true);

  set apiUrl(String value) {
    _apiUrl = _formatApiUrl(value);
  }

  String get apiUrl => _apiUrl;

  Future<http.StreamedResponse> send(
    String method,
    String path, {
    Map<String, String> headers = const {},
    dynamic body,
    bool hasAuth = true,
  }) async {
    final transaction = Sentry.startTransaction(
      'webrequest',
      'request',
      bindToScope: true,
    );

    final route = '$_apiUrl$path';
    final http.BaseRequest request;

    final r = http.Request(method, Uri.parse(route));
    _addBody(r, body);
    request = r;

    log('$method\t$path');

    _addHeaders(request, headers, hasAuth);
    final response = await _client.send(request);

    if (response.isSuccessful()) {
      await transaction.finish(status: const SpanStatus.ok());
      return response;
    }

    final json = (await response.asJson()) as Map<String, dynamic>;
    final err = json['error'];

    if (err == null) {
      throw Exception('Unknown error whilst calling API');
    }

    YFApiException e;
    try {
      e = YFApiException.fromJson(err);
    } catch (_) {
      // Required to handle improperly formatted JSON exceptions
      e = YFApiException.fromText('$err');
    }

    throw e;
  }

  String _formatApiUrl(String apiUrl) {
    return apiUrl.endsWith('/') ? apiUrl : '$apiUrl/';
  }

  void _addHeaders(
    http.BaseRequest request,
    Map<String, String>? header,
    bool hasToken,
  ) {
    if (hasToken) {
      request.headers['apiToken'] = token;
    }

    if (header == null) {
      return;
    }

    for (final key in header.keys) {
      request.headers[key] = header[key]!;
    }
  }

  void _addBody(http.Request request, dynamic body) {
    if (body == null) {
      return;
    }

    if (body is String) {
      request.body = body;
      request.headers['content-type'] = 'text/plain';
      return;
    }

    request.body = jsonEncode(body);
    request.headers['content-type'] = 'application/json';
  }
}

extension TnsStreamedResponse on http.StreamedResponse {
  Future<String> asString() => stream.bytesToString();

  Future<T> asJson<T>() async => jsonDecode(await asString()) as T;

  bool isSuccessful() => statusCode > 199 && statusCode < 300;
}
