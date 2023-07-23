import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/form_text_field.dart';
import 'package:mobile/custom_widgets/password_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/custom_widgets/switch_page_link.dart';
import 'package:mobile/pages/register_page/register_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
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
                "Login",
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
                  PasswordFormField(),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: SubmitButton(
                buttonText: "Sign in",
                onButtonPressed: signInActionButton,
              ),
            ),
            const SpaceBetweenTextFields(),
            SwitchPageLink(
              regularText: "Don't have account yet? ",
              linkText: 'Sign up',
              onLinkPress: () {
                onSignUpLinkPress(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void signInActionButton() {
    //TODO registration button action
  }

  void onSignUpLinkPress(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
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
