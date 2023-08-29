import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/dto/login_dto.dart';
import 'package:mobile/dto/register_dto.dart';
import 'package:mobile/models/error_message_model.dart';
import 'package:mobile/models/register_user_response_model.dart';
import 'package:mobile/models/token_model.dart';

class AuthRepository {
  final String _baseUrl = 'https://10.0.2.2:7275/api';

  Future<dynamic> login(LoginDto loginDto) async {
    final url = '$_baseUrl/User/login';
    final uri = Uri.parse(url);

    final client = http.Client();
    final response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode(loginDto.toJson()),
    );

    if (response.ok) {
      final tokenJson = json.decode(response.body);
      final token = TokenModel.fromJson(tokenJson).token;
      return token;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageModel.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<dynamic> register(RegisterDto registerDto) async {
    final url = '$_baseUrl/User/register';
    final uri = Uri.parse(url);

    final client = http.Client();
    final response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode(registerDto.toJson()),
    );

    if (response.ok) {
      final userJson = json.decode(response.body);
      final userResponse = RegisterUserResponseModel.fromJson(userJson);
      return userResponse;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageModel.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}

extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}
