import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/auth_form_filed/login_form_field.dart';
import 'package:mobile/custom_widgets/auth_form_filed/password_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/custom_widgets/switch_page_link.dart';
import 'package:mobile/pages/login_page/login_page.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Register",
                style: GoogleFonts.rubik(fontSize: 22),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: const Column(
                children: [
                  FormTextField(
                    hintText: 'Email',
                    inputIcon: Icons.email,
                  ),
                  SpaceBetweenTextFields(),
                  FormTextField(
                    hintText: 'Name',
                    inputIcon: Icons.person,
                  ),
                  SpaceBetweenTextFields(),
                  PasswordFormField(),
                  SpaceBetweenTextFields(),
                  PasswordFormField(),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: SubmitButton(
                buttonText: "Sign up",
                onButtonPressed: signUpActionButton,
              ),
            ),
            const SpaceBetweenTextFields(),
            SwitchPageLink(
              regularText: 'Have account already? ',
              linkText: 'Sign in',
              onLinkPress: () {
                onSignInLinkPress(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void signUpActionButton() {
    //TODO registration button action
  }

  void onSignInLinkPress(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}

class SpaceBetweenTextFields extends StatelessWidget {
  const SpaceBetweenTextFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 18,
    );
  }
}
