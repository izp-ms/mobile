import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/form_text_field.dart';

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
              style: GoogleFonts.rubik(fontSize: 20),
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
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer),
              child: Text(
                "Sign up",
                style: GoogleFonts.rubik(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
