import 'package:mobile/api/response/postcard_data_response.dart';

class PostCoordinatesResponse {
  List<PostcardsDataResponse>? postcardsNearby;
  List<PostcardsDataResponse>? postcardsCollected;

  PostCoordinatesResponse({this.postcardsNearby, this.postcardsCollected});

  PostCoordinatesResponse.fromJson(Map<String, dynamic> json) {
    if (json['postcardsNearby'] != null) {
      postcardsNearby = <PostcardsDataResponse>[];
      json['postcardsNearby'].forEach((v) {
        postcardsNearby!.add(PostcardsDataResponse.fromJson(v));
      });
    }
    if (json['postcardsCollected'] != null) {
      postcardsCollected = <PostcardsDataResponse>[];
      json['postcardsCollected'].forEach((v) {
        postcardsCollected!.add(PostcardsDataResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (postcardsNearby != null) {
      data['postcardsNearby'] =
          postcardsNearby!.map((v) => v.toJson()).toList();
    }
    if (postcardsCollected != null) {
      data['postcardsCollected'] =
          postcardsCollected!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
