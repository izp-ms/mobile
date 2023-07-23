import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/auth_form_filed/login_form_field.dart';
import 'package:mobile/custom_widgets/auth_form_filed/password_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/custom_widgets/switch_page_link.dart';
import 'package:mobile/pages/login_page/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
  });

  final double gapBetweenTextFields = 18;

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
                AppLocalizations.of(context).register,
                style: GoogleFonts.rubik(fontSize: 22),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: Column(
                children: [
                  FormTextField(
                    hintText: AppLocalizations.of(context).email,
                    inputIcon: Icons.email,
                  ),
                  SizedBox(height: gapBetweenTextFields),
                  FormTextField(
                    hintText: AppLocalizations.of(context).name,
                    inputIcon: Icons.person,
                  ),
                  SizedBox(height: gapBetweenTextFields),
                  const PasswordFormField(),
                  SizedBox(height: gapBetweenTextFields),
                  PasswordFormField(
                    hintMessage: AppLocalizations.of(context).confirmPassword,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: SubmitButton(
                buttonText: AppLocalizations.of(context).signUp,
                onButtonPressed: signUpActionButton,
              ),
            ),
            SizedBox(height: gapBetweenTextFields),
            SwitchPageLink(
              regularText: AppLocalizations.of(context).haveAccountAlready,
              linkText: AppLocalizations.of(context).signIn,
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
