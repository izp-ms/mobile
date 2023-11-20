import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/country_picker.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';
import 'package:intl/intl.dart';

class FilterDialog extends StatefulWidget {
  final String city;
  final String country;
  final String dateFrom;
  final String dateTo;
  final Function(String, String, String, String) onApply;

  FilterDialog({
    required this.city,
    required this.country,
    required this.dateFrom,
    required this.dateTo,
    required this.onApply,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();

  final DateFormat _dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  String selectedCountry = "";

  @override
  void initState() {
    super.initState();
    cityController.text = widget.city;
    countryController.text = widget.country;
    selectedCountry = widget.country;
    dateFromController.text = widget.dateFrom;
    dateToController.text = widget.dateTo;
  }

  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateFromController.text = _dateFormat.format(picked);
    }
  }

  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateToController.text = _dateFormat.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Postcards'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: cityController,
              decoration: customTextFieldDecoration(
                  context, "City", null),
            ),
            SizedBox(
              height: 15,
            ),
            CustomCountryPicker(
              selectedCountry: selectedCountry,
              onCountryChange: (country) {
                setState(() {
                  selectedCountry = country;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDateFrom(context),
                    child: TextFormField(
                      controller: dateFromController,
                      enabled: false,
                      decoration: customTextFieldDecoration(
                          context, "Date from", Icons.date_range),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDateTo(context),
                    child: TextFormField(
                      controller: dateToController,
                      enabled: false,
                      decoration: customTextFieldDecoration(
                          context, "Date to", Icons.date_range),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Icon(Icons.delete_forever),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.red, // Set the button color to red
          ),
          onPressed: () {
            // Clear all input fields and variables
            cityController.clear();
            countryController.clear();
            dateFromController.clear();
            dateToController.clear();
            selectedCountry = "";
          },
        ),
        ElevatedButton(
          child: Icon(Icons.close),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Icon(Icons.check),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            final city = cityController.text;
            final country = selectedCountry; // Use the selected country
            final dateFrom = dateFromController.text;
            final dateTo = dateToController.text;
            widget.onApply(city, country, dateFrom, dateTo);
          },
        ),
      ],
    );
  }
}
