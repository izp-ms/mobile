import 'package:mobile/api/response/postcard_response.dart';

class PostcardsListResponse {
  int? userId;
  List<int>? content;

  PostcardsListResponse({
    this.userId,
    required this.content,
  });

  PostcardsListResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    content = json['postcardDataIds'].toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postcardDataIds': content,
    };
  }
}
