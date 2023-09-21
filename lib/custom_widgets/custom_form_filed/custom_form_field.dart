import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.hintText,
    this.inputIcon,
    required this.onSaved,
    this.isPasswordField = false,
    this.isRequired = true,
    this.maxLength,
    this.initialValue
  });

  final String? hintText;
  final IconData? inputIcon;
  final FormFieldSetter<String> onSaved;
  final bool isPasswordField;
  final bool isRequired;
  final int? maxLength;
  final String? initialValue;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please enter some value';
        }
        return null;
      },
      initialValue: initialValue,
      style: GoogleFonts.rubik(fontSize: 14),
      decoration: customTextFieldDecoration(context, hintText, inputIcon),
      cursorColor: Theme.of(context).colorScheme.secondary,
      obscureText: isPasswordField,
      enableSuggestions: isPasswordField,
      autocorrect: isPasswordField,
      onSaved: onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: maxLength,
    );
  }
}
