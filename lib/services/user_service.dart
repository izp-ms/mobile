import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/request/user_detail_request.dart';
import 'package:mobile/api/response/error_message_response.dart';
import 'package:mobile/api/response/friend_response.dart';
import 'package:mobile/api/response/friends_list_response.dart';
import 'package:mobile/api/response/user_detail_response.dart';
import 'package:mobile/constants/api_constants.dart';
import 'package:mobile/extensions/is_ok.dart';
import 'package:mobile/services/secure_storage_service.dart';
import 'dart:math';

class UserService {
  final String _baseUrl = ApiConstants.baseUrl;
  static const FETCH_LIMIT = 8;

  Future<dynamic> getUserDetail(int userID) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String currentUserId = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/User/$currentUserId';
    if(userID != -1)
      {
        url = '$_baseUrl/User/$userID';
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


  Future<FriendsListResponse> getAllFriends(
      int pageNumber,
      String search,
      String orderBy) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/User?pageNumber=$pageNumber&pageSize=$FETCH_LIMIT';

    if (search != null && search != "") {
      url = '$url&Search=$search';
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
      final friendsList = FriendsListResponse.fromJson(responseJson);
      return friendsList;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<FriendsListResponse> getFollowing(
      int pageNumber,
      String search,
      String orderBy) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/UserFriends/Following?pageNumber=$pageNumber&pageSize=$FETCH_LIMIT&UserId=$userId';

    if (search != null && search != "") {
      url = '$url&Search=$search';
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
      final friendsList = FriendsListResponse.fromJson(responseJson);
      return friendsList;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<FriendsListResponse> GetFollowedBy(
      int pageNumber,
      String search,
      String orderBy) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/UserFriends/Followers?pageNumber=$pageNumber&pageSize=$FETCH_LIMIT&UserId=$userId';

    if (search != null && search != "") {
      url = '$url&Search=$search';
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
      final friendsList = FriendsListResponse.fromJson(responseJson);
      return friendsList;
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<bool> getIsFollowing(int? FriendID,) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/UserFriends/IsFollowing/$FriendID';
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
      print("IS FOLLOWING RESPONSE");
      print(response.body);
      return response.body.toLowerCase() == 'true';
    } else {
      final errorJson = json.decode(response.body);
      final errorMessage = ErrorMessageResponse.fromJson(errorJson).message;
      throw errorMessage;
    }
  }

  Future<void> updateFollowing(bool newIsFollowing, int? friendId) async {
    final token = await SecureStorageService.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken[
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    var url = '$_baseUrl/UserFriends';
    final uri = Uri.parse(url);

    final client = http.Client();

    if (newIsFollowing) {
      // If newIsFollowing is true, perform a POST request
      final response = await client.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': userId,
          'friendId': friendId,
        }),
      );

      if (response.ok) {
        return;
      } else {
        final errorJson = json.decode(response.body);
        final errorMessage =
            ErrorMessageResponse.fromJson(errorJson).message;
        throw errorMessage;
      }
    } else {
      // If newIsFollowing is false, perform a DELETE request
      final response = await client.delete(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': userId,
          'friendId': friendId,
        }),
      );

      if (response.ok) {
        return;
      } else {
        final errorJson = json.decode(response.body);
        final errorMessage =
            ErrorMessageResponse.fromJson(errorJson).message;
        throw errorMessage;
      }
    }
  }
}
