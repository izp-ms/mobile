import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    super.key,
    required this.dialogTitle,
    required this.dialogContent,
  });

  final String dialogTitle;
  final String dialogContent;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              dialogTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  dialogContent,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
