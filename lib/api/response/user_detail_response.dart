class UserDetailResponse {
  final int id;
  final String? firstName;
  final String? lastName;
  final DateTime birthDate;
  final String? avatarBase64;
  final String? description;
  final String? backgroundBase64;

  UserDetailResponse({
    required this.id,
    this.firstName,
    this.lastName,
    required this.birthDate,
    this.avatarBase64,
    this.description,
    this.backgroundBase64,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate: DateTime.parse(json['birthDate']),
      avatarBase64: json['avatarBase64'],
      description: json['description'],
      backgroundBase64: json['backgroundBase64'],
    );
  }
}
