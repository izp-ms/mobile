class UserDetailResponse {
  final int id;
  final String nickName;
  final String email;
  final DateTime createdAt;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final String? avatarBase64;
  final String? backgroundBase64;
  final String? description;
  final String? city;
  final String? country;
  final int postcardsSent;
  final int postcardsReceived;
  final int score;
  final int postcardsCount;
  final int followersCount;
  final int followingCount;

  UserDetailResponse({
    required this.id,
    required this.nickName,
    required this.email,
    required this.createdAt,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.avatarBase64,
    this.backgroundBase64,
    this.description,
    this.city,
    this.country,
    required this.postcardsSent,
    required this.postcardsReceived,
    required this.score,
    required this.postcardsCount,
    required this.followersCount,
    required this.followingCount,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailResponse(
      id: json['id'],
      nickName: json['nickName'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate:
          json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      avatarBase64: json['avatarBase64'],
      backgroundBase64: json['backgroundBase64'],
      description: json['description'],
      city: json['city'],
      country: json['country'],
      postcardsSent: json['postcardsSent'],
      postcardsReceived: json['postcardsReceived'],
      score: json['score'],
      postcardsCount: json['postcardsCount'],
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
    );
  }
}
