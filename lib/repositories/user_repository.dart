import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/user_detail_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';

class UserRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<dynamic> getUserDetail() async {
    final url = '$_baseUrl/User';
    final uri = Uri.parse(url);
    final token = await SecureStorageRepository.read(key: 'token');

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
}
