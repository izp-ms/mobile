import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_appbars/login_and_registration_app_bar.dart';
import 'package:mobile/pages/login_page/login_page_widgets/login_form.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: loginAndRegistrationAppBar(context),
        body: const LoginForm(),
      ),
    );
  }
}