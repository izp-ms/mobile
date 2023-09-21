import 'dart:convert';

bool isBase64Valid(String? base64) {
  if (base64 == null) return false;
  try {
    base64Decode(base64);
    return true;
  } catch (_) {
    return false;
  }
}