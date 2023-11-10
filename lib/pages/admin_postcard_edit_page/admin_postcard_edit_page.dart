import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/admin_cubit/admin_cubit.dart';
import 'package:mobile/cubit/admin_cubit/admin_state.dart';
import 'package:mobile/custom_widgets/country_picker.dart';
import 'package:mobile/custom_widgets/custom_appbars/app_bar_with_back_button.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/custom_form_filed/custom_form_field.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';

class AdminPostcardEditPage extends StatefulWidget {
  const AdminPostcardEditPage({
    super.key,
    this.postcard,
    this.isEditingMode = false,
  });

  final PostcardsDataResponse? postcard;
  final bool isEditingMode;

  @override
  State<AdminPostcardEditPage> createState() => _AdminPostcardEditPageState();
}

class _AdminPostcardEditPageState extends State<AdminPostcardEditPage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  static const double separatorSize = 20;
  static const double postCardHeight = 100;

  String? _imageBase64;
  String? _country;
  String? _city;
  String? _title;
  String? _longitude;
  String? _latitude;
  String? _collectRangeInMeters;

  @override
  void initState() {
    super.initState();
    _imageBase64 = widget.postcard?.imageBase64?.substring(23);
    _country = widget.postcard?.country ?? "Poland";
    _city = widget.postcard?.city;
    _title = widget.postcard?.title;
    _longitude = widget.postcard?.longitude;
    _latitude = widget.postcard?.latitude;
    _collectRangeInMeters = widget.postcard?.collectRangeInMeters.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackButton(),
      drawer: CustomDrawer(context),
      body: BlocConsumer<AdminCubit, AdminState>(listener: (context, state) {
        if (state is ErrorState) {
          showErrorSnackBar(context, state.errorMessage);
        }
      }, builder: (context, state) {
        return Center(
          child: Form(
            key: _formKey,
            child: ListView.separated(
              padding: const EdgeInsets.all(separatorSize),
              itemCount: 8,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: separatorSize);
              },
              itemBuilder: (BuildContext context, int index) {
                switch (index) {
                  case 0:
                    return _postcardImagePicker(context);
                  case 1:
                    return _countryPicker(context);
                  case 2:
                    return CustomFormField(
                      hintText: 'City',
                      initialValue: _city,
                      isRequired: true,
                      onSaved: (newValue) {
                        if (newValue == null) return;
                        _city = newValue;
                      },
                    );
                  case 3:
                    return CustomFormField(
                      hintText: 'Title',
                      initialValue: _title,
                      isRequired: true,
                      onSaved: (newValue) {
                        if (newValue == null) return;
                        _title = newValue;
                      },
                    );
                  case 4:
                    return CustomFormField(
                      hintText: 'Longitude',
                      initialValue: _longitude,
                      isRequired: true,
                      onlyNumeric: true,
                      onSaved: (newValue) {
                        if (newValue == null) return;
                        _longitude = newValue;
                      },
                    );
                  case 5:
                    return CustomFormField(
                      hintText: 'Latitude',
                      initialValue: _latitude,
                      isRequired: true,
                      onlyNumeric: true,
                      onSaved: (newValue) {
                        if (newValue == null) return;
                        _latitude = newValue;
                      },
                    );
                  case 6:
                    return CustomFormField(
                      hintText: 'Collect Range (in meters)',
                      initialValue: _collectRangeInMeters,
                      isRequired: true,
                      onlyNumeric: true,
                      onSaved: (newValue) {
                        if (newValue == null) return;
                        _collectRangeInMeters = newValue;
                      },
                    );
                  case 7:
                    return SubmitButton(
                      buttonText: AppLocalizations.of(context).save,
                      isLoading: state is LoadingState,
                      onButtonPressed: () {
                        savePostcardData(context);
                      },
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Row _postcardImagePicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: (isBase64Valid(_imageBase64))
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.memory(
                        base64Decode(_imageBase64!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Container(
                        height: postCardHeight,
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
                _pickImage();
              },
            ),
          ),
        ),
      ],
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
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    Uint8List imageByte = await image.readAsBytes();
    String base64Encoded = base64.encode(imageByte);

    setState(() {
      _imageBase64 = base64Encoded;
    });
  }

  Future<void> savePostcardData(BuildContext context) async {
    if (_imageBase64 == null) {
      showErrorSnackBar(context, "You must provide image.");
    }
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();

      final adminCubit = context.read<AdminCubit>();

      if (widget.isEditingMode){
        final postcardDto = PostcardsDataResponse(
            id: widget.postcard?.id,
            imageBase64: "data:image/jpeg;base64,$_imageBase64",
            country: _country,
            city: _city,
            title: _title,
            longitude: _longitude,
            latitude: _latitude,
            collectRangeInMeters: int.parse(_collectRangeInMeters!),
            createdAt: DateFormat('yyyy-MM-ddTHH:mm:ss')
                .format(DateTime.now())
                .toString());

        try {
          await adminCubit
              .editPostcardData(postcardDto)
              .then((value) => Navigator.of(context).pop());
        } catch (e) {
          showErrorSnackBar(context, "An error occurred: $e");
        }
      } else {
        final postcardDto = PostcardsDataResponse(
            id: 0,
            imageBase64: "data:image/jpeg;base64,$_imageBase64",
            country: _country,
            city: _city,
            title: _title,
            longitude: _longitude,
            latitude: _latitude,
            collectRangeInMeters: int.parse(_collectRangeInMeters!),
            createdAt: DateFormat('yyyy-MM-ddTHH:mm:ss')
                .format(DateTime.now())
                .toString());

        try {
          await adminCubit
              .addPostcardData(postcardDto)
              .then((value) => Navigator.of(context).pop());
        } catch (e) {
          showErrorSnackBar(context, "An error occurred: $e");
        }
      }
    }
  }
}
