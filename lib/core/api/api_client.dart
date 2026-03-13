import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Нужен для kDebugMode, kIsWeb и TargetPlatform
import 'package:shared_preferences/shared_preferences.dart';

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
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('jwt_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}
