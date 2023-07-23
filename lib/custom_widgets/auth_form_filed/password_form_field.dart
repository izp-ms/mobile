import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/auth_form_filed/styled.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordFormField extends StatelessWidget {
  const PasswordFormField({super.key, this.hintMessage});

  final String? hintMessage;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: GoogleFonts.rubik(fontSize: 14),
      decoration: authTextFieldDecoration(
        context,
        getHintMessage(context),
        Icons.lock,
      ),
      cursorColor: Theme.of(context).colorScheme.secondary,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
    );
  }

  getHintMessage(context) {
    return hintMessage ?? AppLocalizations.of(context).password;
  }
}
