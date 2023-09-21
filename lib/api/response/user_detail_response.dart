class UserDetailResponse {
  final int id;
  final String nickName;
  final String email;
  final String role;
  final DateTime createdAt;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final String? avatarBase64;
  final String? backgroundBase64;
  final String? description;
  final String? city;
  final String? country;
  final String? countryCode;
  final int postcardsSent;
  final int postcardsReceived;
  final int score;

  UserDetailResponse({
    required this.id,
    required this.nickName,
    required this.email,
    required this.role,
    required this.createdAt,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.avatarBase64,
    this.backgroundBase64,
    this.description,
    this.city,
    this.country,
    this.countryCode,
    required this.postcardsSent,
    required this.postcardsReceived,
    required this.score,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailResponse(
      id: json['id'],
      nickName: json['nickName'],
      email: json['email'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      avatarBase64: json['avatarBase64'],
      backgroundBase64: json['backgroundBase64'],
      description: json['description'],
      city: json['city'],
      country: json['country'],
      countryCode: json['countryCode'],
      postcardsSent: json['postcardsSent'],
      postcardsReceived: json['postcardsReceived'],
      score: json['score'],
    );
  }
}
