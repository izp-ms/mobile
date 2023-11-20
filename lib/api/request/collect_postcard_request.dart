import 'package:mobile/api/request/coordinates_request.dart';

class CollectPostcardRequest {
  final CoordinatesRequest coordinatesRequest;
  final int postcardDataId;

  CollectPostcardRequest({
    required this.coordinatesRequest,
    required this.postcardDataId,
  });

  Map<String, dynamic> toJson() {
    return {
      'coordinateRequest': coordinatesRequest.toJson(),
      'postcardDataId': postcardDataId,
    };
  }
}
