import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/request/register_request.dart';
import 'package:mobile/cubit/auth_cubit/auth_cubit.dart';
import 'package:mobile/cubit/auth_cubit/auth_state.dart';
import 'package:mobile/custom_widgets/custom_form_filed/custom_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/custom_widgets/switch_page_link.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/helpers/show_success_snack_bar.dart';
import 'package:mobile/pages/login_page/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({
    super.key,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool _isSignUpPressed = false;
  final double gapBetweenTextFields = 18;

  final _formKey = GlobalKey<FormState>();

  String _userEmail = '';

  String _userName = '';

  String _userPassword = '';

  String _userConfirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          showSuccessSnackBar(context, "Successfully register user.");
          context.read<AuthCubit>().resetState();
          _navigateToLoginPage(context);
        } else if (state is ErrorState) {
          showErrorSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
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
                      AppLocalizations.of(context).register,
                      style: GoogleFonts.rubik(fontSize: 22),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Column(
                      children: [
                        CustomFormField(
                          onSaved: (newValue) {
                            if (newValue == null) return;
                            _userEmail = newValue;
                          },
                          hintText: AppLocalizations.of(context).email,
                          inputIcon: Icons.email,
                        ),
                        SizedBox(height: gapBetweenTextFields),
                        CustomFormField(
                          onSaved: (newValue) {
                            if (newValue == null) return;
                            _userName = newValue;
                          },
                          hintText: AppLocalizations.of(context).nickName,
                          inputIcon: Icons.person,
                        ),
                        SizedBox(height: gapBetweenTextFields),
                        CustomFormField(
                          onSaved: (newValue) {
                            if (newValue == null) return;
                            _userPassword = newValue;
                          },
                          hintText: AppLocalizations.of(context).password,
                          inputIcon: Icons.lock,
                          isPasswordField: true,
                          canToogleVisibility: true,
                        ),
                        SizedBox(height: gapBetweenTextFields),
                        CustomFormField(
                          onSaved: (newValue) {
                            if (newValue == null) return;
                            _userConfirmPassword = newValue;
                          },
                          validator: (value) {
                            if (_isSignUpPressed && _userPassword != value) {
                              return AppLocalizations.of(context).noMatchingPassword;
                            }
                            return null;
                          },
                          hintText: AppLocalizations.of(context).password,
                          inputIcon: Icons.lock,
                          isPasswordField: true,
                          canToogleVisibility: true,
                          onChanged: (value) {
                            _isSignUpPressed = false;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: SubmitButton(
                      isLoading: (state is LoadingState),
                      buttonText: AppLocalizations.of(context).signUp,
                      onButtonPressed: () {
                        signUpActionButton(context);
                      },
                    ),
                  ),
                  SizedBox(height: gapBetweenTextFields),
                  SwitchPageLink(
                    regularText:
                        AppLocalizations.of(context).haveAccountAlready,
                    linkText: AppLocalizations.of(context).signIn,
                    onLinkPress: () {
                      onSignInLinkPress(context);
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

  Future<void> signUpActionButton(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();

      if(_userPassword != _userConfirmPassword)
      {
        setState(() {
          _isSignUpPressed = true;
        });
        return;
      }
      else
        {
          bool _isSignUpPressed = false;
        }

      final authCubit = context.read<AuthCubit>();

      final registerDto = RegisterRequest(
        email: _userEmail,
        nickName: _userName,
        password: _userPassword,
        confirmPassword: _userConfirmPassword,
      );

      try {
        await authCubit.registerUser(registerDto);
      } catch (e) {
        showErrorSnackBar(context, "An error occurred: $e");
      }
    }
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void onSignInLinkPress(BuildContext context) {
    context.read<AuthCubit>().resetState();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
