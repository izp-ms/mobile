import 'package:mobile/api/response/postcard_response.dart';

class PostcardsCollectionListResponse {
  int? userId;
  List<dynamic>? content;

  PostcardsCollectionListResponse({
    this.userId,
    required this.content,
  });

  PostcardsCollectionListResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    content = json['postcardDataIds'].toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postcardDataIds': content,
    };
  }

  static PostcardsCollectionListResponse createDefault() {
    return PostcardsCollectionListResponse(
      userId: null, // Set default values as needed
      content: <dynamic>[],
    );
  }

  static PostcardsCollectionListResponse empty() {
    return PostcardsCollectionListResponse(
      userId: 0,
      content: [],
    );
  }
}