import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CustomCountryPicker extends StatelessWidget {
  final String? selectedCountry;
  final ValueChanged<String> onCountryChange;

  const CustomCountryPicker({
    super.key,
    required this.selectedCountry,
    required this.onCountryChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 61,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {
          showCountryPicker(
            context: context,
            countryListTheme: const CountryListThemeData(
              flagSize: 25,
              bottomSheetHeight: 500,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            onSelect: (Country country) {
              onCountryChange(country.name);
            },
          );
        },
        child: Row(
          children: [
            Text(
              _getButtonText(),
              style: TextStyle(
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

  String _getButtonText() {
    return (selectedCountry == null || selectedCountry == '')
        ? "Country"
        : selectedCountry!;
  }
}
