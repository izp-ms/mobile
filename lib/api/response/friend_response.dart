import 'package:mobile/helpers/date_extractor.dart';

class FriendResponse {
  int? id;
  String? nickName;
  String? email;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? avatarBase64;
  String? backgroundBase64;
  String? description;
  String? city;
  String? country;
  int? postcardsSent;
  int? postcardsReceived;
  int? score;
  int? postcardsCount;
  int? followersCount;
  int? followingCount;

  FriendResponse({
    this.id,
    this.nickName,
    this.email,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.avatarBase64,
    this.backgroundBase64,
    this.description,
    this.city,
    this.country,
    this.postcardsSent,
    this.postcardsReceived,
    this.score,
    this.postcardsCount,
    this.followersCount,
    this.followingCount,
  });

  FriendResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickName = json['nickName'];
    email = json['email'];
    createdAt = dateExtractor(json['createdAt']);
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthDate = json['birthDate'];
    avatarBase64 = json['avatarBase64'];
    backgroundBase64 = json['backgroundBase64'];
    description = json['description'];
    city = json['city'];
    country = json['country'];
    postcardsSent = json['postcardsSent'] ?? 0;
    postcardsReceived = json['postcardsReceived'] ?? 0;
    score = json['score'] ?? 0;
    postcardsCount = json['postcardsCount'] ?? 0;
    followersCount = json['followersCount'] ?? 0;
    followingCount = json['followingCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nickName'] = nickName;
    data['email'] = email;
    data['createdAt'] = dateExtractor(createdAt);
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['birthDate'] = birthDate;
    data['avatarBase64'] = avatarBase64;
    data['backgroundBase64'] = backgroundBase64;
    data['description'] = description;
    data['city'] = city;
    data['country'] = country;
    data['postcardsSent'] = postcardsSent ?? 0;
    data['postcardsReceived'] = postcardsReceived ?? 0;
    data['score'] = score ?? 0;
    data['postcardsCount'] = postcardsCount ?? 0;
    data['followersCount'] = followersCount ?? 0;
    data['followingCount'] = followingCount ?? 0;
    return data;
  }
}