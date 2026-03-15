import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    String baseUrl = 'https://courtmaster-backend.onrender.com/api';
    if (kDebugMode) {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        baseUrl = 'http://10.0.2.2:3000/api';
      } else {
        baseUrl = 'http://localhost:3000/api';
      }
    }

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          String customMessage = 'Неизвестная ошибка сервера';

          if (error.response?.data != null) {
            final data = error.response!.data;

            if (data is Map && data['message'] != null) {
              customMessage = data['message'].toString();
            } else if (data is List &&
                data.isNotEmpty &&
                data.first is Map &&
                data.first['message'] != null) {
              customMessage = data.first['message'].toString();
            } else {
              customMessage =
                  'Сбой сервера (Код ${error.response?.statusCode})';
            }
          } else {
            customMessage = error.message ?? 'Нет ответа от сервера';
          }

          final safeResponse = Response(
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode,
            data: {'message': customMessage},
          );

          final customError = DioException(
            requestOptions: error.requestOptions,
            response: safeResponse,
            type: error.type,
            error: customMessage,
          );

          return handler.next(customError);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}
