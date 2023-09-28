class PostcardDataResponse {
  final int id;
  final String imageBase64;
  final String country;
  final String city;
  final String longitude;
  final String latitude;

  PostcardDataResponse({
    required this.id,
    required this.imageBase64,
    required this.country,
    required this.city,
    required this.longitude,
    required this.latitude,
  });

  factory PostcardDataResponse.fromJson(Map<String, dynamic> json) {
    return PostcardDataResponse(
      id: json['id'],
      imageBase64: json['imageBase64'],
      country: json['country'],
      city: json['city'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}