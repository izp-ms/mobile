import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/api/request/user_detail_request.dart';
import 'package:mobile/api/response/user_detail_response.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/custom_widgets/country_picker.dart';
import 'package:mobile/custom_widgets/custom_appbars/app_bar_with_back_button.dart';
import 'package:mobile/custom_widgets/custom_date_picker.dart';
import 'package:mobile/custom_widgets/custom_form_filed/custom_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/pages/profile_page/profile_page.dart';

enum Images { avatar, background }

class EditUserDetailsPage extends StatefulWidget {
  const EditUserDetailsPage({required this.userDetail, super.key});

  final UserDetailResponse userDetail;

  @override
  State<EditUserDetailsPage> createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  late DateTime? date;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  static const double separatorSize = 20;
  static const double constraintSize = 200;
  static const double avatarCircleSize = 100;
  static const double backgroundHeight = 100;

  String? _backgroundImageBase64;
  String? _avatarImageBase64;
  String? _userName;
  String? _userSecondName;
  String? _country;
  String? _aboutMe;

  @override
  void initState() {
    super.initState();
    date = widget.userDetail.birthDate;
    _backgroundImageBase64 = widget.userDetail.backgroundBase64;
    _avatarImageBase64 = widget.userDetail.avatarBase64;
    _userName = widget.userDetail.firstName;
    _userSecondName = widget.userDetail.lastName;
    _country = widget.userDetail.country;
    _aboutMe = widget.userDetail.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButton(),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is ErrorState) {
              showErrorSnackBar(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 3 * constraintSize),
                child: Form(
                  key: _formKey,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(separatorSize),
                    itemCount: 7,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: separatorSize);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      switch (index) {
                        case 0:
                          return _imagesSection(context);
                        case 1:
                          return CustomFormField(
                            hintText: 'Name',
                            initialValue: _userName,
                            isRequired: false,
                            onSaved: (newValue) {
                              if (newValue == null) return;
                              _userName = newValue;
                            },
                          );
                        case 2:
                          return CustomFormField(
                            hintText: 'Second name',
                            initialValue: _userSecondName,
                            isRequired: false,
                            onSaved: (newValue) {
                              if (newValue == null) return;
                              _userSecondName = newValue;
                            },
                          );
                        case 3:
                          return _birthdayPicker(context);
                        case 4:
                          return _countryPicker(context);
                        case 5:
                          return CustomFormField(
                            hintText: 'About me',
                            initialValue: _aboutMe,
                            isRequired: false,
                            maxLength: 500,
                            onSaved: (newValue) {
                              if (newValue == null) return;
                              _aboutMe = newValue;
                            },
                          );
                        case 6:
                          return SubmitButton(
                            buttonText: AppLocalizations.of(context).save,
                            isLoading: state is LoadingState,
                            onButtonPressed: () {
                              saveUserData(context);
                            },
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  ClipRRect _countryPicker(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomCountryPicker(
                selectedCountry: _country,
                onCountryChange: (newCountry) {
                  setState(() {
                    _country = newCountry;
                  });
                },
              ),
            ),
            if (_country != null && _country != '')
              IconButton(
                onPressed: () {
                  setState(() {
                    _country = null;
                  });
                },
                icon: const Icon(Icons.close),
              )
          ],
        ),
      ),
    );
  }

  ClipRRect _birthdayPicker(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomDatePicker(
                selectedDate: date,
                onDateChange: (newDate) {
                  setState(() {
                    date = newDate;
                  });
                },
              ),
            ),
            if (date != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    date = null;
                  });
                },
                icon: const Icon(Icons.close),
              )
          ],
        ),
      ),
    );
  }

  Column _imagesSection(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 2 * constraintSize,
          ),
          child: _backgroundImagePicker(context),
        ),
        const SizedBox(
          height: separatorSize,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 2 * constraintSize,
          ),
          child: _profileImagePicker(context),
        ),
      ],
    );
  }

  Row _profileImagePicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Center(
              child: (isBase64Valid(_avatarImageBase64))
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(avatarCircleSize),
                      child: SizedBox(
                        width: avatarCircleSize,
                        height: avatarCircleSize,
                        child: Image.memory(
                          base64Decode(_avatarImageBase64!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(
                      width: avatarCircleSize,
                      height: avatarCircleSize,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SubmitButton(
              buttonText: AppLocalizations.of(context).pickPhoto,
              onButtonPressed: () {
                _pickImage(imageType: Images.avatar);
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _backgroundImagePicker(BuildContext context) {
    print(isBase64Valid(_backgroundImageBase64));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: (isBase64Valid(_backgroundImageBase64))
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: Image.memory(
                        base64Decode(_backgroundImageBase64!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: Container(
                        height: backgroundHeight,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SubmitButton(
              buttonText: AppLocalizations.of(context).pickPhoto,
              onButtonPressed: () {
                _pickImage(imageType: Images.background);
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> saveUserData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();

      final userCubit = context.read<UserCubit>();

      final userDto = UserDetailRequest(
          id: widget.userDetail.id,
          firstName: _userName,
          lastName: _userSecondName,
          birthDate: date == null ? null : date.toString(),
          avatarBase64: _avatarImageBase64,
          backgroundBase64: _backgroundImageBase64,
          description: _aboutMe,
          country: _country);

      try {
        await userCubit
            .putUserDetail(userDto)
            .then((value) => _navigateToProfilePage(context));
      } catch (e) {
        showErrorSnackBar(context, "An error occurred: $e");
      }
    }
  }

  void _navigateToProfilePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _pickImage({required Images imageType}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    Uint8List imageByte = await image.readAsBytes();
    String base64Encoded = base64.encode(imageByte);

    switch (imageType) {
      case Images.background:
        setState(() {
          _backgroundImageBase64 = base64Encoded;
        });
        break;
      case Images.avatar:
        setState(() {
          _avatarImageBase64 = base64Encoded;
        });
        break;
    }
  }
}
