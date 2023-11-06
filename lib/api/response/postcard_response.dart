class PostcardsResponse {
  int? id;
  String? title;
  String? content;
  int? postcardDataId;
  String? type;
  DateTime? createdAt;
  int? userId;
  bool isSent = false;
  String? imageBase64;
  String? country;
  String? city;
  String? postcardDataTitle;
  String? longitude;
  String? latitude;
  int? collectRangeInMeters;

  PostcardsResponse(
      {  this.id,
        this.title,
        this.content,
        this.postcardDataId,
        this.type,
        this.createdAt,
        this.userId,
        required this.isSent,
        this.imageBase64,
        this.country,
        this.city,
        this.postcardDataTitle,
        this.longitude,
        this.latitude,
        this.collectRangeInMeters,});

  @override
  String toString() {
    return 'PostcardsResponse(id: $id, title: $title, content: $content';
  }

  PostcardsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    postcardDataId = json['postcardDataId'];
    type = json['type'];
    createdAt = DateTime.parse(json['createdAt']);
    userId = json['userId'];
    isSent = json['isSent'] ?? false;
    imageBase64 = json['imageBase64'];
    country = json['country'];
    city = json['city'];
    postcardDataTitle = json['postcardDataTitle'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    collectRangeInMeters = json['collectRangeInMeters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['postcardDataId'] = postcardDataId;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['userId'] = userId;
    data['isSent'] = isSent;
    data['imageBase64'] = imageBase64;
    data['country'] = country;
    data['city'] = city;
    data['postcardDataTitle'] = postcardDataTitle;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['collectRangeInMeters'] = collectRangeInMeters;
    return data;
  }
}