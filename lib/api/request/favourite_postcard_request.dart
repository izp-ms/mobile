class FavouritePostcardRequest {
  List<PostcardIdsWithOrders>? postcardIdsWithOrders;

  FavouritePostcardRequest({this.postcardIdsWithOrders});

  FavouritePostcardRequest.fromJson(Map<String, dynamic> json) {
    if (json['postcardIdsWithOrders'] != null) {
      postcardIdsWithOrders = <PostcardIdsWithOrders>[];
      json['postcardIdsWithOrders'].forEach((v) {
        postcardIdsWithOrders!.add(PostcardIdsWithOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (postcardIdsWithOrders != null) {
      data['postcardIdsWithOrders'] =
          postcardIdsWithOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostcardIdsWithOrders {
  int? postcardId;
  int? orderId;

  PostcardIdsWithOrders({this.postcardId, this.orderId});

  PostcardIdsWithOrders.fromJson(Map<String, dynamic> json) {
    postcardId = json['postcardId'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postcardId'] = postcardId;
    data['orderId'] = orderId;
    return data;
  }
}
