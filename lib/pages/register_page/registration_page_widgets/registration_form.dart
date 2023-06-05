import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/form_text_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                FormTextField(
                  hintText: 'Password',
                  inputIcon: Icons.lock,
                ),
                SpaceBetweenTextFields(),
                FormTextField(
                  hintText: 'Confirm password',
                  inputIcon: Icons.lock,
                ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Have account already? ",
                style: GoogleFonts.rubik(fontSize: 14),
              ),
              Text(
                "Sign in",
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  signUpActionButton() {
    //TODO registration button action
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
