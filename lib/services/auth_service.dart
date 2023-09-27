import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/api/request/login_request.dart';
import 'package:mobile/api/request/register_request.dart';
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/register_user_response.dart';
import 'package:mobile/api/response/token_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';

class AuthService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<dynamic> login(LoginRequest loginRequest) async {
    final url = '$_baseUrl/User/login';
    final uri = Uri.parse(url);

    final client = http.Client();
    final response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode(loginRequest.toJson()),
    );

    if (response.ok) {
      final tokenJson = json.decode(response.body);
      final token = TokenResponse.fromJson(tokenJson).token;
      return token;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<dynamic> register(RegisterRequest registerRequest) async {
    final url = '$_baseUrl/User/register';
    final uri = Uri.parse(url);

    final client = http.Client();
    final response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode(registerRequest.toJson()),
    );

    if (response.ok) {
      final userJson = json.decode(response.body);
      final userResponse = RegisterUserResponse.fromJson(userJson);
      return userResponse;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}


