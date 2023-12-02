import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/request/favourite_postcard_request.dart';
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/postcard_response.dart';
import 'package:mobile/api/response/postcards_collection_response.dart';
import 'package:mobile/api/response/postcards_data_list_response.dart';
import 'package:mobile/api/response/postcards_list_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';
import 'package:mobile/services/secure_storage_service.dart';

class PostcardService {
  final String _baseUrl = ApiConstants.baseUrl;
  static const FETCH_LIMIT = 12;

  Future<PostcardsDataListResponse> getPostcardData(
      int pageNumber,
      bool showAllPostcardsCollection,
      String search,
      String city,
      String country,
      String dateFrom,
      String dateTo,
      String orderBy) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url =
        '$_baseUrl/PostcardData?pageNumber=$pageNumber&pageSize=$FETCH_LIMIT';
    if (!showAllPostcardsCollection) {
      url = '$url&userId=$userId';
    }
    if (search != null && search != "") {
      url = '$url&Search=$search';
    }

    if (city != null && city != "") {
      url = '$url&City=$city';
    }

    if (country != null && country != "") {
      url = '$url&Country=$country';
    }

    if (dateFrom != null && dateFrom != "") {
      String modifiedDate = dateFrom.replaceAll(":", "%3A");
      url = '$url&DateFrom=$modifiedDate';
    }

    if (dateTo != null && dateTo != "") {
      String modifiedDate = dateTo.replaceAll(":", "%3A");
      url = '$url&DateTo=$modifiedDate';
    }

    if (orderBy != null && orderBy != "") {
      url = '$url&OrderBy=$orderBy';
    }

    //PostcardData?PageNumber=1&PageSize=12&Search=Palmiarnia&City=Gliwice&Country=Poland&DateFrom=2001-03-15T00%3A00%3A00&DateTo=2024-03-15T00%3A00%3A00&OrderBy=-date'

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
      final postcardData = PostcardsDataListResponse.fromJson(responseJson);
      return postcardData;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<PostcardsCollectionListResponse> getPostcardDataCollection() async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/PostcardCollection?userId=$userId';
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
      final postcardsList = PostcardsCollectionListResponse.fromJson(responseJson);
      return postcardsList;
    }  else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<PostcardsListResponse> getPostcards(
      int pageNumber,
      bool isSent,
      String search,
      String city,
      String country,
      String dateFrom,
      String dateTo,
      String orderBy) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/Postcard?pageNumber=$pageNumber&pageSize=$FETCH_LIMIT';
    url = '$url&userId=$userId';

    url = '$url&IsSent=$isSent';

    if (search != null && search != "") {
      url = '$url&Search=$search';
    }

    if (city != null && city != "") {
      url = '$url&City=$city';
    }

    if (country != null && country != "") {
      url = '$url&Country=$country';
    }

    if (dateFrom != null && dateFrom != "") {
      String modifiedDate = dateFrom.replaceAll(":", "%3A");
      url = '$url&DateFrom=$modifiedDate';
    }

    if (dateTo != null && dateTo != "") {
      String modifiedDate = dateTo.replaceAll(":", "%3A");
      url = '$url&DateTo=$modifiedDate';
    }

    if (orderBy != null && orderBy != "") {
      url = '$url&OrderBy=$orderBy';
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
      final postcardsList = PostcardsListResponse.fromJson(responseJson);
      return postcardsList;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<PostcardsListResponse> getFavouritePostcards() async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
    var url = '$_baseUrl/FavouritePostcard?userId=$userId';
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
      final responseJson = json.decode(response.body) as List;
      final List<PostcardsResponse> postcardsList =
          responseJson.map((json) => PostcardsResponse.fromJson(json)).toList();

      final postcardsListResponse =
          PostcardsListResponse(content: postcardsList);
      return postcardsListResponse;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<void> putFavouritePostcards(
      FavouritePostcardRequest favouritePostcardRequest) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
    var url = '$_baseUrl/FavouritePostcard';
    final uri = Uri.parse(url);

    final client = http.Client();
    final response = await client.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(favouritePostcardRequest.toJson()),
    );

    if (response.ok) {
      return;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<PostcardsListResponse> getFriendFavouritePostcards(int? FriendID) async {
    final token = await SecureStorageService.read(key: 'token');
    var url = '$_baseUrl/FavouritePostcard?userId=$FriendID';
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
      final responseJson = json.decode(response.body) as List;
      final List<PostcardsResponse> postcardsList =
      responseJson.map((json) => PostcardsResponse.fromJson(json)).toList();

      final postcardsListResponse =
      PostcardsListResponse(content: postcardsList);
      return postcardsListResponse;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }
}
