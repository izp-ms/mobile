import 'package:flutter/material.dart';
import 'package:mobile/pages/login_page/login_page_widgets/login_app_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAppBar(context)
    );
  }
}
