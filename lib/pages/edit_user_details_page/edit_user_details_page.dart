import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/api/response/user_detail_response.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Images { avatar, background }

class EditUserDetailsPage extends StatefulWidget {
  const EditUserDetailsPage({required this.userDetail, super.key});

  final UserDetailResponse userDetail;

  @override
  State<EditUserDetailsPage> createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  double pagePadding = 10;

  String? _backgroundImageBase64;
  String? _avatarImageBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
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
      body: BlocConsumer<UserCubit, UserState>(
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
                      child: (isBase64Valid(_backgroundImageBase64!))
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width:
                        MediaQuery.of(context).size.width * 0.5 - pagePadding,
                    child: Center(
                      child: (isBase64Valid(_avatarImageBase64!))
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
              SubmitButton(
                buttonText: AppLocalizations.of(context).save,
                onButtonPressed: () {
                  print(_backgroundImageBase64);
                  print("===");
                  print(_avatarImageBase64);
                },
              ),
            ],
          );
        },
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

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}
