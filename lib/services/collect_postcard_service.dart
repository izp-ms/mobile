import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/api/request/coordinates_request.dart';
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/post_coordinates_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';
import 'package:mobile/services/secure_storage_service.dart';

class CollectPostcardService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<dynamic> postCoordinates(CoordinatesRequest coordinatesRequest) async {
    final url = '$_baseUrl/PostcardData/NewPostcard';
    final uri = Uri.parse(url);
    final token = await SecureStorageService.read(key: 'token');

    print(url);

    final client = http.Client();
    final response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(coordinatesRequest.toJson()),
    );

    print(response.statusCode);

    if (response.ok) {
      final responseJson = json.decode(response.body);
      final postcards = PostCoordinatesResponse.fromJson(responseJson);
      return postcards;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}