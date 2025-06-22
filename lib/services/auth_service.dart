import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:rota_gourmet/screens/auth/sign_in_screen.dart';

class AuthService {
  // Configuração baseada no ambiente
  final String keycloakBaseUrl = const String.fromEnvironment(
    'KEYCLOAK_URL',
    defaultValue: "https://signin.hml.api.flentra.com"
  );
  final String realm = "rota-gourmet"; 
  final String clientId = "rota-gourmet-app";
  final String cert = "JRtF4KKbYJ5YlL66wsDsPHd0gQEQqLPs"; 
  late final Dio _dio;

  // Chave global para navegação
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Método para definir a chave de navegação (chamar na inicialização do app)
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  AuthService() {
    _dio = Dio();
    
    // Configuração do Dio para iOS
    if (Platform.isIOS) {
      final httpClientAdapter = IOHttpClientAdapter();
      httpClientAdapter.createHttpClient = () {
        final client = HttpClient();
        // No iOS, precisamos ser mais específicos com os certificados
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          // Log para debug em produção
          print('SSL Certificate check for host: $host');
          // Verificar se o host é o esperado
          return host.contains('signin.hml.api.flentra.com');
        };
        return client;
      };
      _dio.httpClientAdapter = httpClientAdapter;
    }

    // Configuração de timeout
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    // Interceptor para logging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  /// Método para login com credenciais
  Future<Map<String, dynamic>?> loginWithCredentials(
      String username, String password) async {
    final tokenUrl =
        "$keycloakBaseUrl/realms/$realm/protocol/openid-connect/token";

    try {
      print('Attempting login to: $tokenUrl');
      final response = await _dio.post(
        tokenUrl,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) {
            return status! < 500;
          },
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

      print('Login response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Salvar tanto o access token quanto o refresh token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.data['access_token']);
        if (response.data['refresh_token'] != null) {
          await prefs.setString('refresh_token', response.data['refresh_token']);
        }
        return response.data;
      }
    } on DioException catch (e) {
      print('DioException during login:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Error: ${e.error}');
      if (e.response != null) {
        print("Erro de autenticação: ${e.response?.data}");
      } else {
        print("Erro na requisição: ${e.message}");
      }
    } catch (e) {
      print('Unexpected error during login: $e');
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
        // Obter o ID do usuário recém-criado
        final userDetails = await _getUserDetails(adminToken, username);
        if (userDetails != null) {
          final userId = userDetails['id'];
          
          // Obter a role app_member
          final rolesUrl = "$keycloakBaseUrl/admin/realms/$realm/roles";
          final rolesResponse = await _dio.get(
            rolesUrl,
            options: Options(
              headers: {'Authorization': 'Bearer $adminToken'},
            ),
          );
          
          final appMemberRole = rolesResponse.data.firstWhere(
            (role) => role['name'] == 'app_member',
            orElse: () => null,
          );
          
          if (appMemberRole != null) {
            // Adicionar a role ao usuário
            await _dio.post(
              "$keycloakBaseUrl/admin/realms/$realm/users/$userId/role-mappings/realm",
              options: Options(
                headers: {'Authorization': 'Bearer $adminToken'},
                contentType: 'application/json',
              ),
              data: [appMemberRole],
            );
          }
        }
        return userDetails;
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

  /// Método para validar o token armazenado e fazer login automático
  Future<Map<String, dynamic>?> validateStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');
    final refreshToken = prefs.getString('refresh_token');
    
    if (storedToken == null || refreshToken == null) return null;

    // Check if token is expired or will expire soon (e.g., in 1 minute)
    bool isTokenExpired = false;
    try {
      isTokenExpired = JwtDecoder.isExpired(storedToken);
      final expirationDate = JwtDecoder.getExpirationDate(storedToken);
      if (expirationDate.difference(DateTime.now()).inMinutes < 1) {
        isTokenExpired = true;
      }
    } catch (e) {
      // Handle potential decoding errors
      isTokenExpired = true;
    }

    if (!isTokenExpired) {
      // Token is still valid, return it
      return {'access_token': storedToken};
    }

    // If token is expired, try to refresh
    return this.refreshToken(refreshToken);
  }

  /// Método para refrescar o token de acesso usando o refresh token
  Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    final tokenUrl = "$keycloakBaseUrl/realms/$realm/protocol/openid-connect/token";
    try {
      final response = await _dio.post(
        tokenUrl,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
        data: {
          'grant_type': 'refresh_token',
          'client_id': clientId,
          'client_secret': cert,
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.data['access_token']);
        if (response.data['refresh_token'] != null) {
          await prefs.setString('refresh_token', response.data['refresh_token']);
        }
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Erro ao refrescar token: ${e.response?.data}");
      } else {
        print("Erro na requisição de refresh: ${e.message}");
      }
    }
    return null;
  }

  /// Método para logout
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) return true; // Already logged out

    final logoutUrl = "$keycloakBaseUrl/realms/$realm/protocol/openid-connect/logout";

    try {
      final response = await _dio.post(
        logoutUrl,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
        data: {
          'client_id': clientId,
          'client_secret': cert,
          'refresh_token': refreshToken,
        },
      );

      // Mesmo se conseguirmos remover os tokens localmente. A API pode retornar
      // outros códigos (como 400 se o refresh token já expirou no servidor),
      // mas localmente o usuário estará deslogado.
      if (response.statusCode == 204 || response.statusCode == 200) {
        await prefs.remove('auth_token');
        await prefs.remove('refresh_token');
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        }
        return true;
      } else {
         // Logar outros status codes que não sejam 200 ou 204, mas ainda tentar limpar tokens
        print("Logout API retornou status: ${response.statusCode}");
        await prefs.remove('auth_token');
        await prefs.remove('refresh_token');
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        }
        return false;
      }
    } on DioException catch (e) {
       // Se der erro na chamada, ainda assim tentar limpar os tokens locais
      print("Erro durante o logout: ${e.response?.data ?? e.message}");
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
        );
      }
      return false;
    } catch (e) {
       print("Erro inesperado durante o logout: $e");
       await prefs.remove('auth_token');
       await prefs.remove('refresh_token');
       if (navigatorKey.currentState != null) {
         navigatorKey.currentState!.pushAndRemoveUntil(
           MaterialPageRoute(builder: (context) => const SignInScreen()),
           (route) => false,
         );
       }
       return false;
    }
  }
}