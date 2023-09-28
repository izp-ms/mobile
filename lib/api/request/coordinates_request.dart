class CoordinatesRequest {
  final String longitude;
  final String latitude;

  CoordinatesRequest({
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}