import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class AuthService {
  final String keycloakBaseUrl = "https://signin.flentra.com";
  final String realm = "rota-gourmet"; 
  final String clientId = "app-rota-gourmet";
  final String cert = "AxQhg3MdRDsqaGpHEMX5uLtzifZRD4FL"; // Substitua pela senha do admin
  late final Dio _dio;

  AuthService() {
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

  /// Método para login com credenciais
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
          'client_secret': cert,
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

  /// Método para registrar um novo usuário
  Future<Map<String, dynamic>?> registerUser({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    bool emailVerified = true,
    bool enabled = true,
  }) async {
    final adminToken = await _getAdminToken();
    if (adminToken == null) return null;

    final usersUrl = "$keycloakBaseUrl/admin/realms/$realm/users";

    try {
      final response = await _dio.post(
        usersUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $adminToken',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "username": username,
          "email": email,
          "firstName": firstName,
          "lastName": lastName,
          "enabled": enabled,
          "emailVerified": emailVerified,
          "credentials": [
            {
              "type": "password",
              "value": password,
              "temporary": false
            }
          ]
        },
      );

      if (response.statusCode == 201) {
        return await _getUserDetails(adminToken, username);
      }
    } on DioException catch (e) {
      print("Erro no registro: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  /// Método auxiliar para obter token de administração
  Future<String?> _getAdminToken() async {
    final tokenUrl = "$keycloakBaseUrl/realms/$realm/protocol/openid-connect/token";
    
    try {
      final response = await _dio.post(
        tokenUrl,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
        data: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': cert,
        },
      );
      return response.data['access_token'];
    } on DioException catch (e) {
      print("Erro ao obter token de admin: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  /// Método auxiliar para obter detalhes do usuário
  Future<Map<String, dynamic>?> _getUserDetails(String adminToken, String username) async {
    final usersUrl = "$keycloakBaseUrl/admin/realms/$realm/users?username=$username";
    
    try {
      final response = await _dio.get(
        usersUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $adminToken'},
        ),
      );
      return response.data.isNotEmpty ? response.data[0] : null;
    } on DioException catch (e) {
      print("Erro ao buscar usuário: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  /// Método para verificar se o usuário existe
  Future<bool> checkUserExists(String username) async {
    final adminToken = await _getAdminToken();
    if (adminToken == null) return false;

    try {
      final response = await _dio.get(
        "$keycloakBaseUrl/admin/realms/$realm/users?username=$username",
        options: Options(
          headers: {'Authorization': 'Bearer $adminToken'},
        ),
      );
      return response.data.isNotEmpty;
    } on DioException {
      return false;
    }
  }

  /// Método para enviar email de verificação
  Future<bool> sendVerificationEmail(String userId) async {
    final adminToken = await _getAdminToken();
    if (adminToken == null) return false;

    try {
      await _dio.put(
        "$keycloakBaseUrl/admin/realms/$realm/users/$userId/send-verify-email",
        options: Options(
          headers: {'Authorization': 'Bearer $adminToken'},
        ),
        data: {
          "clientId": clientId,
          "redirectUri": "https://suaapp.com/verified" // Substitua pela sua URL
        },
      );
      return true;
    } on DioException catch (e) {
      print("Erro ao enviar email: ${e.response?.data ?? e.message}");
      return false;
    }
  }
}