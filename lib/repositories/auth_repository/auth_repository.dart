import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/error_message_model.dart';
import 'package:mobile/models/token_model.dart';

class AuthRepository {
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
      final tokenJson = json.decode(response.body);
      print(tokenJson);
      final token = TokenModel.fromJson(tokenJson).token;
      return token;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageModel.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}
