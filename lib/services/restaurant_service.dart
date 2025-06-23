import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_gourmet/services/auth_service.dart';

class RestaurantService {
  final String baseUrl = "https://rotagourmet.hml.api.flentra.com";
  late final Dio _dio;
  final AuthService _authService = AuthService();

  RestaurantService() {
    _dio = Dio();
    
    // Configuração para ignorar erros de certificado SSL
    final httpClientAdapter = IOHttpClientAdapter();
    httpClientAdapter.createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = 
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dio.httpClientAdapter = httpClientAdapter;

    // Adicionar interceptor para refresh token
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        // Se for um erro 401 (Unauthorized) e a requisição original não for a de refresh token
        if (error.response?.statusCode == 401 &&
            error.requestOptions.path != "/realms/rota-gourmet/protocol/openid-connect/token") {
          try {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refresh_token');

            if (refreshToken != null) {
              // Tentar refrescar o token
              final newTokens = await _authService.refreshToken(refreshToken);

              if (newTokens != null && newTokens['access_token'] != null) {
                // Salvar o novo token
                await prefs.setString('auth_token', newTokens['access_token']);

                // Repetir a requisição original com o novo token
                final newHeaders = Map<String, dynamic>.from(error.requestOptions.headers);
                newHeaders['Authorization'] = 'Bearer ${newTokens['access_token']}';
                newHeaders.removeWhere((key, value) => key.toLowerCase() == 'authorization' && key != 'Authorization'); // Remove old case-insensitive auth header if it exists

                final cloneReq = await _dio.request(
                  error.requestOptions.path,
                  options: Options(
                      method: error.requestOptions.method,
                      headers: {
                        ...newHeaders, // Use the explicitly built map
                      },
                      extra: error.requestOptions.extra, // Include extra options if any
                    ),
                    data: error.requestOptions.data,
                    queryParameters: error.requestOptions.queryParameters,
                  );
                return handler.resolve(cloneReq); // Resolver com a nova resposta
              } else {
                // Se o refresh token falhou, deslogar
                await _authService.logout();
                // Redirecionar para a tela de login (implementar navegação aqui se necessário)
                // Pode ser necessário passar um contexto ou usar um Navigator key global
                return handler.reject(error); // Rejeitar o erro original
              }
            } else {
              // Não há refresh token, deslogar
              await _authService.logout();
              // Redirecionar para a tela de login
              return handler.reject(error); // Rejeitar o erro original
            }
          } catch (e) {
            // Erro durante o refresh token ou repetição da requisição, deslogar
            print("Erro no interceptor durante refresh/repetição: $e");
            await _authService.logout();
            // Redirecionar para a tela de login
            return handler.reject(error); // Rejeitar o erro original
          }
        } else {
          // Não é erro 401 ou já é a requisição de refresh, passar o erro adiante
          return handler.next(error);
        }
      },
    ));
  }

  /// Método para obter o token de autenticação
  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print("Erro ao obter token: $e");
      return null;
    }
  }

  /// Método para buscar restaurantes próximos
  Future<Map<String, dynamic>?> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    int page = 1,
    int pageSize = 20,
    List<int>? workTimes,
    List<int>? workDays,
    List<int>? categoryIds,
  }) async {
    final endpoint = "/api/mobile/restaurant/close";
    final token = await _getAuthToken();

    final Map<String, dynamic> queryParameters = {
      'Latitude': latitude,
      'Longitude': longitude,
      'Page': page,
      'PageSize': pageSize,
    };

    if (workTimes != null && workTimes.isNotEmpty) {
      queryParameters['WorkTimes'] = workTimes.map((e) => e.toString()).toList();
    }
    if (workDays != null && workDays.isNotEmpty) {
      queryParameters['WorkDays'] = workDays.map((e) => e.toString()).toList();
    }
    if (categoryIds != null && categoryIds.isNotEmpty) {
      queryParameters['CategoryId'] = categoryIds.map((e) => e.toString()).toList();
    }

    try {
      final response = await _dio.get(
        "$baseUrl$endpoint",
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'accept': '*/*',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Erro na requisição: [33m");
        print(e.response?.data);
      } else {
        print("Erro na conexão: [33m");
        print(e.message);
      }
    }
    
    return null;
  }
}