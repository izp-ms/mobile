import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/login_and_registration_app_bar.dart';

import '../../custom_widgets/form_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAndRegistrationAppBar(context),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text(
              "Register",
              style: GoogleFonts.rubik(fontSize: 20),
            ),
            const FormTextField(
              hintText: 'Email',
              inputIcon: Icons.email,
            ),
            const SizedBox(
              height: 10,
            ),
            const FormTextField(
              hintText: 'Name',
              inputIcon: Icons.person,
            ),
            const SizedBox(
              height: 10,
            ),
            const FormTextField(
              hintText: 'Password',
              inputIcon: Icons.lock,
            ),
            const SizedBox(
              height: 10,
            ),
            const FormTextField(
              hintText: 'Confirm password',
              inputIcon: Icons.lock,
            ),
          ],
        ),
      ),
    );
  }
}
