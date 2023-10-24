import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/postcards_data_list_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';
import 'package:mobile/services/secure_storage_service.dart';

class PostcardService {
  final String _baseUrl = ApiConstants.baseUrl;
  static const FETCH_LIMIT = 12;

  Future<PostcardsDataListResponse> getPostcardData(int pageNumber, bool showAllPostcardsCollection) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/PostcardData?pageNumber=$pageNumber&pageSize=$FETCH_LIMIT';
    if(!showAllPostcardsCollection){
      url = '$_baseUrl/PostcardData?pageNumber=$pageNumber&pageSize=$FETCH_LIMIT&userId=$userId';
    }

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
      final postcardDataCollection = PostcardsDataListResponse.fromJson(responseJson);
      return postcardDataCollection;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}