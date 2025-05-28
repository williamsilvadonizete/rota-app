import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantService {
  final String baseUrl = "https://rotagourmet.hml.api.flentra.com";
  late final Dio _dio;

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
  }) async {
    final endpoint = "/api/restaurant/close";
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "$baseUrl$endpoint",
        queryParameters: {
          'Latitude': latitude,
          'Longitude': longitude,
          'Page': page,
          'PageSize': pageSize,
        },
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
        print("Erro na requisição: ${e.response?.data}");
      } else {
        print("Erro na conexão: ${e.message}");
      }
    }
    
    return null;
  }

  /// Método genérico para requisições autenticadas
  Future<Response?> _authenticatedRequest({
    required String method,
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _getAuthToken();
    
    try {
      return await _dio.request(
        "$baseUrl$endpoint",
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: {
            'accept': '*/*',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      print("Erro na requisição autenticada: ${e.message}");
      rethrow;
    }
  }
}