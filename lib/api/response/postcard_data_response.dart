class PostcardsDataResponse {
  int? id;
  String? imageBase64;
  String? country;
  String? city;
  String? title;
  String? longitude;
  String? latitude;
  int? collectRangeInMeters;

  PostcardsDataResponse(
      {this.id,
      this.imageBase64,
      this.country,
      this.city,
      this.title,
      this.longitude,
      this.latitude,
      this.collectRangeInMeters});

  PostcardsDataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageBase64 = json['imageBase64'];
    country = json['country'];
    city = json['city'];
    title = json['title'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    collectRangeInMeters = json['collectRangeInMeters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageBase64'] = imageBase64;
    data['country'] = country;
    data['city'] = city;
    data['title'] = title;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['collectRangeInMeters'] = collectRangeInMeters;
    return data;
  }
}
