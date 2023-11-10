import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';
import 'package:mobile/services/secure_storage_service.dart';

class AdminService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<dynamic> editPostcardData(PostcardsDataResponse postcardsDataResponse) async {
    final url = '$_baseUrl/PostcardData';
    final uri = Uri.parse(url);
    final token = await SecureStorageService.read(key: 'token');

    final client = http.Client();
    final response = await client.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(postcardsDataResponse.toJson()),
    );

    if (response.ok) {
      final postcardJson = json.decode(response.body);
      final postcardResponse = PostcardsDataResponse.fromJson(postcardJson);
      return postcardResponse;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<dynamic> addPostcardData(PostcardsDataResponse postcardsDataResponse) async {
    final url = '$_baseUrl/PostcardData';
    final uri = Uri.parse(url);
    final token = await SecureStorageService.read(key: 'token');

    final client = http.Client();
    final response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(postcardsDataResponse.toJson()),
    );

    if (response.ok) {
      final postcardJson = json.decode(response.body);
      final postcardResponse = PostcardsDataResponse.fromJson(postcardJson);
      return postcardResponse;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}
