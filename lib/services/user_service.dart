import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/request/user_detail_request.dart';
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/user_detail_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';
import 'package:mobile/services/secure_storage_service.dart';

class UserService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<dynamic> getUserDetail() async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    final url = '$_baseUrl/User?userId=$userId';
    final uri = Uri.parse(url);


    final client = http.Client();
    final response = await client.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.ok) {
      final responseJson = json.decode(response.body);
      final userDetail = UserDetailResponse.fromJson(responseJson);
      return userDetail;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<dynamic> putUserDetail(UserDetailRequest userDetailRequest) async {
    final url = '$_baseUrl/User';
    final uri = Uri.parse(url);
    final token = await SecureStorageService.read(key: 'token');

    final client = http.Client();
    final response = await client.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(userDetailRequest.toJson()),
    );

    if (response.ok) {
      final userJson = json.decode(response.body);
      final userResponse = UserDetailRequest.fromJson(userJson);
      return userResponse;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}
