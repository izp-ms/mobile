import 'dart:convert';

bool isBase64Valid(String? base64) {
  if (base64 == null) return false;
  try {
    print(base64.length);
    base64Decode(base64);
    print("true");
    return true;
  } catch (_) {
    print("false");
    return false;
  }
}