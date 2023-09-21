import 'package:flutter/material.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
  );
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}