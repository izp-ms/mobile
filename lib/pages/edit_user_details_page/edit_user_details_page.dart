import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/api/response/user_detail_response.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
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
    date = _todaysDate();
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
                        Expanded(child: _customDatePicker()),
                        if (date != _todaysDate())
                          IconButton(
                            onPressed: () {
                              setState(() {
                                date = _todaysDate();
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
                const CustomTextFormField(hintText: 'About me'),
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

  DateTime _todaysDate() {
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  Widget _customDatePicker() {
    return SizedBox(
      height: 61,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 14.0),
          ),
          elevation: MaterialStateProperty.all(0.0),
          backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.onBackground),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        onPressed: _showDatePicker,
        child: Row(
          children: [
            Text(
              _birthDayButtonContent(),
              style: GoogleFonts.rubik(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    DateTime? newDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).brightness == Brightness.light
                ? ColorScheme.light(
                    primary: Theme.of(context).colorScheme.secondaryContainer,
                  )
                : ColorScheme.dark(
                    primary: Theme.of(context).colorScheme.secondaryContainer,
                  ),
            primaryColor: Theme.of(context).colorScheme.secondaryContainer,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }

  String _birthDayButtonContent() {
    return (date == todayDate())
        ? "Birthday"
        : "${date.day}.${date.month}.${date.year}";
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
