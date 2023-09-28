import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';

class PostcardRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<dynamic> getPostcardData() async {
    final token = await SecureStorageRepository.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    final url = '$_baseUrl/PostcardCollection?userId=$userId';
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
      final postcardDetail = PostcardDataResponse.fromJson(responseJson); // Using PostcardResponse to decode
      return postcardDetail;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}