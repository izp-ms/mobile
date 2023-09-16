import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/api/response/user_detail_response.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/custom_widgets/custom_date_picker.dart';
import 'package:mobile/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/helpers/todaysDate.dart';

enum Images { avatar, background }

class EditUserDetailsPage extends StatefulWidget {
  const EditUserDetailsPage({required this.userDetail, super.key});

  final UserDetailResponse userDetail;

  @override
  State<EditUserDetailsPage> createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  double pagePadding = 10;
  late DateTime date;
  String? _backgroundImageBase64;
  String? _avatarImageBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    date = todayDate();
    _backgroundImageBase64 = widget.userDetail.backgroundBase64;
    _avatarImageBase64 = widget.userDetail.avatarBase64;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 30),
          iconSize: 30,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is ErrorState) {
              showErrorSnackBar(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 2 * pagePadding),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.5 - pagePadding,
                      child: Center(
                        child: (isBase64Valid(_backgroundImageBase64))
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: Image.memory(
                                    base64Decode(_backgroundImageBase64!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 200,
                                  height: 100,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                      ),
                    ),
                    SubmitButton(
                      buttonText: AppLocalizations.of(context).pickPhoto,
                      onButtonPressed: () {
                        _pickImage(imageType: Images.background);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.5 - pagePadding,
                      child: Center(
                        child: (isBase64Valid(_avatarImageBase64))
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.memory(
                                    base64Decode(_avatarImageBase64!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ),
                    ),
                    SubmitButton(
                      buttonText: AppLocalizations.of(context).pickPhoto,
                      onButtonPressed: () {
                        _pickImage(imageType: Images.avatar);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomTextFormField(hintText: 'Name'),
                const SizedBox(
                  height: 20,
                ),
                const CustomTextFormField(hintText: 'Second name'),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
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
                        if (date != todayDate())
                          IconButton(
                            onPressed: () {
                              setState(() {
                                date = todayDate();
                              });
                            },
                            icon: const Icon(Icons.close),
                          )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomTextFormField(hintText: 'Country'),
                const SizedBox(
                  height: 20,
                ),
                const CustomTextFormField(
                  hintText: 'About me',
                  maxLength: 500,
                ),
                const SizedBox(
                  height: 20,
                ),
                SubmitButton(
                  buttonText: AppLocalizations.of(context).save,
                  onButtonPressed: () {
                    print(_backgroundImageBase64);
                    print("===");
                    print(_avatarImageBase64);
                    print("===");
                    print(date.toString());
                  },
                ),
              ],
            );
          },
        ),
      ),
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
