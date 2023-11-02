import 'package:mobile/api/response/postcard_response.dart';

class PostcardsListResponse {
  int? pageNumber;
  int? pageSize;
  int? totalCount;
  int? totalPages;
  List<PostcardsResponse>? content;

  PostcardsListResponse({
    this.pageNumber,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    required this.content,
  });

  PostcardsListResponse.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
    content = (json['content'] as List).map((e) => PostcardsResponse.fromJson(e)).toList();
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
