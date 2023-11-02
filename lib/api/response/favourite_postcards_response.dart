import 'package:mobile/api/response/postcard_response.dart';

class FavouritePostcardsResponse {
  List<PostcardsResponse>? content;

  FavouritePostcardsResponse({
    required this.content,
  });

  FavouritePostcardsResponse.fromJson(Map<String, dynamic> json) {
    content = (json as List).map((e) => PostcardsResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content?.map((e) => e.toJson()).toList();
    return data;
  }
}
