import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/custom_text_form_field/styled.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText = '',
    this.inputIcon,
    this.maxLength,
  });

  final String? hintText;
  final IconData? inputIcon;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      style: GoogleFonts.rubik(fontSize: 14),
      decoration: customTextFormFieldDecoration(context, hintText, inputIcon),
      cursorColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
