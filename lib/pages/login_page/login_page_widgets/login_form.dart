import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/auth_form_filed/login_form_field.dart';
import 'package:mobile/custom_widgets/auth_form_filed/password_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/custom_widgets/switch_page_link.dart';
import 'package:mobile/pages/login_page/cubit/login_cubit.dart';
import 'package:mobile/pages/login_page/cubit/login_state.dart';
import 'package:mobile/pages/register_page/register_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final double gapBetweenTextFields = 18;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoadingLoginState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      AppLocalizations.of(context).login,
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
                        const PasswordFormField(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: SubmitButton(
                      buttonText: AppLocalizations.of(context).signIn,
                      onButtonPressed: () => signInActionButton(context),
                    ),
                  ),
                  SizedBox(height: gapBetweenTextFields),
                  SwitchPageLink(
                    regularText:
                        AppLocalizations.of(context).dontHaveAccountYet,
                    linkText: AppLocalizations.of(context).signUp,
                    onLinkPress: () {
                      onSignUpLinkPress(context);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void signInActionButton(context) {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void onSignUpLinkPress(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }
}
