class CoordinatesRequest {
  final String longitude;
  final String latitude;
  final int postcardNotificationRangeInMeters;

  CoordinatesRequest({
    required this.longitude,
    required this.latitude,
    required this.postcardNotificationRangeInMeters,
  });

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'postcardNotificationRangeInMeters': postcardNotificationRangeInMeters,
    };
  }
}
