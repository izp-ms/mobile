import 'package:mobile/api/response/friend_response.dart';

class FriendsListResponse {
  int? pageNumber;
  int? pageSize;
  int? totalCount;
  int? totalPages;
  List<FriendResponse>? content;

  FriendsListResponse({
    this.pageNumber,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    required this.content,
  });

  FriendsListResponse.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
    content = (json['content'] as List).map((e) => FriendResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['totalPages'] = totalPages;
    data['content'] = content?.map((e) => e.toJson()).toList();
    return data;
  }
}