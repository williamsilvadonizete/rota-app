import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class AuthService {
  final String keycloakBaseUrl = "https://signin.flentra.com";
  final String realm = "rota-gourmet"; 
  final String clientId = "app-rota-gourmet";
  late final Dio _dio;

  AuthService() {
    _dio = Dio();
    
  // Configuração atualizada para ignorar erros de certificado SSL
  final httpClientAdapter = IOHttpClientAdapter();
  httpClientAdapter.createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = 
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dio.httpClientAdapter = httpClientAdapter;
  }

  Future<Map<String, dynamic>?> loginWithCredentials(
      String username, String password) async {
    final tokenUrl =
        "$keycloakBaseUrl/realms/$realm/protocol/openid-connect/token";

    try {
      final response = await _dio.post(
        tokenUrl,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
        data: {
          'grant_type': 'password',
          'client_id': clientId,
          'username': username,
          'password': password,
          'scope': 'openid',
          'client_secret': 'AxQhg3MdRDsqaGpHEMX5uLtzifZRD4FL',
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Erro de autenticação: ${e.response?.data}");
      } else {
        print("Erro na requisição: ${e.message}");
      }
    }
    
    return null;
  }
}