import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String keycloakBaseUrl = "http://localhost:8080";
  final String realm = "Rota"; 
  final String clientId = "rota-gourmet-app";

  Future<Map<String, dynamic>?> loginWithCredentials(
      String username, String password) async {
    final tokenUrl =
        "$keycloakBaseUrl/realms/$realm/protocol/openid-connect/token";

    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'password',
        'client_id': clientId,
        'username': username,
        'password': password,
        'scope': 'openid',
        'client_secret': 'Lvz5PAjvslRfJR1VRDWbU9ENHR4biz7z',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Erro de autenticação: ${response.body}");
      return null;
    }
  }
}
