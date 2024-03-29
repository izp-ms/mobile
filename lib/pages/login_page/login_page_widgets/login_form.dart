import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/request/login_request.dart';
import 'package:mobile/cubit/auth_cubit/auth_cubit.dart';
import 'package:mobile/cubit/auth_cubit/auth_state.dart';
import 'package:mobile/custom_widgets/custom_form_filed/custom_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/custom_widgets/switch_page_link.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/postcards_page/postcards_page.dart';
import 'package:mobile/pages/profile_page/profile_page.dart';
import 'package:mobile/pages/register_page/register_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/providers/admin_provider.dart';
import 'package:mobile/services/secure_storage_service.dart';
import 'package:provider/provider.dart';

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
  String _userEmail = '';
  String _userPassword = '';
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          _navigateToPostcardsPage(context);
          context.read<AuthCubit>().resetState();
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
                      AppLocalizations.of(context).login,
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
                          autovalidateMode: AutovalidateMode.disabled,
                        ),
                        SizedBox(height: gapBetweenTextFields),
                        CustomFormField(
                          onSaved: (newValue) {
                            if (newValue == null) return;
                            _userPassword = newValue;
                          },
                          hintText: AppLocalizations.of(context).password,
                          isPasswordField: _isPasswordHidden,
                          canToogleVisibility: true,
                          autovalidateMode: AutovalidateMode.disabled,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Consumer(
                        builder: (context, AdminProvider adminProvider, child) {
                      return SubmitButton(
                        isLoading: (state is LoadingState),
                        buttonText: AppLocalizations.of(context).signIn,
                        onButtonPressed: () =>
                            signInActionButton(context, adminProvider),
                      );
                    }),
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

  Future<void> signInActionButton(
      BuildContext context, AdminProvider adminProvider) async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();

      final loginCubit = context.read<AuthCubit>();

      final loginDto = LoginRequest(
        email: _userEmail,
        password: _userPassword,
      );

      try {
        await loginCubit.loginUser(loginDto);
      } catch (e) {
        showErrorSnackBar(context, "An error occurred: $e");
      }

      final token = await SecureStorageService.read(key: 'token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

      if (decodedToken.containsKey(
              'http://schemas.microsoft.com/ws/2008/06/identity/claims/role') &&
          decodedToken[
                  'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ==
              'ADMIN') {
        adminProvider.isAdmin = true;
      } else {
        adminProvider.isAdmin = false;
      }
    }
  }

  Future<void> _navigateToPostcardsPage(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  void onSignUpLinkPress(BuildContext context) {
    context.read<AuthCubit>().resetState();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }
}
