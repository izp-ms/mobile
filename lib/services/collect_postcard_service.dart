import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
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

    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioc);
    final response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(coordinatesRequest.toJson()),
    );

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