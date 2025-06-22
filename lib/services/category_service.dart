import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:rota_gourmet/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  final String baseUrl = "https://rotagourmet.hml.api.flentra.com";
  late final Dio _dio;
  final AuthService _authService = AuthService();

  CategoryService() {
    _dio = Dio();

    // Configuração para ignorar erros de certificado SSL
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // Adicionar interceptor para refresh token
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401 &&
            error.requestOptions.path !=
                "/realms/rota-gourmet/protocol/openid-connect/token") {
          try {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refresh_token');

            if (refreshToken != null) {
              final newTokens = await _authService.refreshToken(refreshToken);

              if (newTokens != null && newTokens['access_token'] != null) {
                await prefs.setString('auth_token', newTokens['access_token']);

                final newHeaders =
                    Map<String, dynamic>.from(error.requestOptions.headers);
                newHeaders['Authorization'] =
                    'Bearer ${newTokens['access_token']}';

                final cloneReq = await _dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: newHeaders,
                    extra: error.requestOptions.extra,
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                return handler.resolve(cloneReq);
              } else {
                await _authService.logout();
                return handler.reject(error);
              }
            } else {
              await _authService.logout();
              return handler.reject(error);
            }
          } catch (e) {
            await _authService.logout();
            return handler.reject(error);
          }
        } else {
          return handler.next(error);
        }
      },
    ));
  }

  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print("Erro ao obter token: $e");
      return null;
    }
  }

  Future<List<dynamic>?> getActiveCategories() async {
    const endpoint = "/api/mobile/category/active";
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "$baseUrl$endpoint",
        options: Options(
          headers: {
            'accept': '*/*',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Erro na requisição: ${e.response?.data}");
      } else {
        print("Erro na conexão: ${e.message}");
      }
    }

    return null;
  }
} 