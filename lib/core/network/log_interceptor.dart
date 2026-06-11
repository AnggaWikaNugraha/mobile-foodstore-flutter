import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

String _prettyJson(dynamic data) {
  try {
    return const JsonEncoder.withIndent('  ').convert(data);
  } catch (_) {
    return data.toString();
  }
}

// debugPrint dipecah 800 char supaya tidak terpotong di iOS syslog
void _log(String message) {
  if (!kDebugMode) return;
  const chunk = 800;
  for (var i = 0; i < message.length; i += chunk) {
    debugPrint(message.substring(i, (i + chunk).clamp(0, message.length)));
  }
}

class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _log('┌─────────────────────────────────────');
      _log('│ 🚀 REQUEST');
      _log('│ ${options.method} ${options.uri}');
      if (options.queryParameters.isNotEmpty) {
        _log('│ params: ${options.queryParameters}');
      }
      if (options.data != null) {
        _log('│ body: ${_prettyJson(options.data)}');
      }
      _log('└─────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _log('┌─────────────────────────────────────');
      _log('│ ✅ RESPONSE ${response.statusCode}');
      _log('│ ${response.requestOptions.method} ${response.requestOptions.uri}');
      _log(_prettyJson(response.data));
      _log('└─────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _log('┌─────────────────────────────────────');
      _log('│ ❌ ERROR ${err.response?.statusCode}');
      _log('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
      _log('│ ${err.message}');
      if (err.response?.data != null) {
        _log(_prettyJson(err.response?.data));
      }
      _log('└─────────────────────────────────────');
    }
    handler.next(err);
  }
}
