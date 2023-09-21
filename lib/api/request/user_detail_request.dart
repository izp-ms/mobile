import 'package:mobile/helpers/date_extractor.dart';

class UserDetailRequest {
  int? id;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? avatarBase64;
  String? backgroundBase64;
  String? description;
  String? country;

  UserDetailRequest({
    this.id,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.avatarBase64,
    this.backgroundBase64,
    this.description,
    this.country,
  });

  factory UserDetailRequest.fromJson(Map<String, dynamic> json) {
    return UserDetailRequest(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : dateExtractor(json['birthDate']),
      avatarBase64: json['avatarBase64'] as String?,
      backgroundBase64: json['backgroundBase64'] as String?,
      description: json['description'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': dateExtractor(birthDate),
      'avatarBase64': avatarBase64,
      'backgroundBase64': backgroundBase64,
      'description': description,
      'country': country,
    };
  }
}
