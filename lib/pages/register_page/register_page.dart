import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/login_and_registration_app_bar.dart';
import 'package:mobile/pages/register_page/registration_page_widgets/registration_form.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAndRegistrationAppBar(context),
      body: RegistrationForm(),
    );
  }
}
