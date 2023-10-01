import 'dart:typed_data';

Uint8List? getImageUint8List(imageBase64) {
  final imageData = imageBase64!;
  final UriData? data = Uri.parse(imageData).data;
  return data?.contentAsBytes();
}