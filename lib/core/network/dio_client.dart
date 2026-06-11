import 'package:dio/dio.dart';
import 'log_interceptor.dart';

const String baseUrl = 'https://foodstore-server-nu.vercel.app';

class DioClient {
  static final Dio _dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(AppLogInterceptor());
    return dio;
  }

  static Dio get instance => _dio;
}
