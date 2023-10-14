class PostcardsDataResponse {
  int? pageNumber;
  int? pageSize;
  int? totalCount;
  int? totalPages;
  List<PostcardsData>? content;

  PostcardsDataResponse({
    this.pageNumber,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    required this.content,
  });

  PostcardsDataResponse.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
    content = (json['content'] as List).map((e) => PostcardsData.fromJson(e)).toList();
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

class PostcardsData {
  int? id;
  String? imageBase64;
  String? country;
  String? city;
  String? title;
  String? longitude;
  String? latitude;
  int? collectRangeInMeters;

  PostcardsData(
      {this.id,
        this.imageBase64,
        this.country,
        this.city,
        this.title,
        this.longitude,
        this.latitude,
        this.collectRangeInMeters});

  PostcardsData.fromJson(Map<String, dynamic> json) {
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