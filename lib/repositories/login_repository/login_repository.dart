import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginRepository {
  Future<dynamic> login(String email, String password) async {
    const url = 'https://10.0.2.2:7275/api/User/login';
    final uri = Uri.parse(url);

    final client = http.Client();
    final response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final token = response.body;
      return token;
    } else {
      throw "Something went wrong code ${response.statusCode}";
    }
  }
}
