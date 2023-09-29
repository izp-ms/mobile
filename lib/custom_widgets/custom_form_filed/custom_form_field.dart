import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomFormField extends StatefulWidget {
  CustomFormField({
    Key? key,
    this.hintText,
    this.inputIcon,
    required this.onSaved,
    this.isPasswordField = false,
    this.canToogleVisibility = false,
    this.isRequired = true,
    this.maxLength,
    this.initialValue,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final String? hintText;
  final IconData? inputIcon;
  final FormFieldSetter<String> onSaved;
  final bool isPasswordField;
  final bool canToogleVisibility;
  final bool isRequired;
  final int? maxLength;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _isPasswordField;

  @override
  void initState() {
    super.initState();
    _isPasswordField = widget.isPasswordField;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordField = !_isPasswordField;
    });
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    // At least one upper case letter, one lower case letter, and either one number or one special character, and be at least 8 characters long
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[\d@$!%*?&])[A-Za-z\d@$!%*?&]{8,}');
    return passwordRegex.hasMatch(password);
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      validator: widget.validator ?? (value) {
          if (widget.isRequired && (value == null || value.isEmpty)) {
            return 'Please enter some value';
          }

          if (widget.hintText == AppLocalizations.of(context).email && !_isValidEmail(value!)) {
            return 'Enter a valid email';
          }

          if (widget.hintText == AppLocalizations.of(context).password && !_isStrongPassword(value!)) {
            return 'Provide strong password';
          }

          return null;
        },
      initialValue: widget.initialValue,
      style: GoogleFonts.rubik(fontSize: 14),
      cursorColor: Theme.of(context).colorScheme.secondary,
      obscureText: _isPasswordField,
      enableSuggestions: widget.canToogleVisibility,
      autocorrect: widget.canToogleVisibility,
      onSaved: widget.onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: widget.maxLength,
      decoration: widget.canToogleVisibility
          ? customTextFieldDecoration(context, widget.hintText, widget.inputIcon).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordField ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      )
          : customTextFieldDecoration(context, widget.hintText, widget.inputIcon),
    );
  }

}
