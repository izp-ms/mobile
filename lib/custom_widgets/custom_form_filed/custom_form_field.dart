import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';

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
  }) : super(key: key);

  final String? hintText;
  final IconData? inputIcon;
  final FormFieldSetter<String> onSaved;
  final bool isPasswordField;
  final bool canToogleVisibility;
  final bool isRequired;
  final int? maxLength;
  final String? initialValue;

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


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return 'Please enter some value';
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
