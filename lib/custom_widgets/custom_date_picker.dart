import 'package:flutter/material.dart';
import 'package:mobile/helpers/todaysDate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChange;

  const CustomDatePicker({
    super.key,
    this.selectedDate,
    required this.onDateChange,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  String? dateFormatPreference;

  @override
  void initState() {
    super.initState();
    _loadDateFormatPreference();
  }

  void _loadDateFormatPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dateFormatPreference = prefs.getString('toggleDateValue') ?? "DD.MM.YYYY";
    });
  }

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
          _showDatePicker(context);
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
    if (widget.selectedDate == null) return "Birthday";

    if (dateFormatPreference == "MM.DD.YYYY") {
      return "${widget.selectedDate?.month}.${widget.selectedDate?.day}.${widget.selectedDate?.year}";
    }

    return "${widget.selectedDate?.day}.${widget.selectedDate?.month}.${widget.selectedDate?.year}";
  }

  void _showDatePicker(BuildContext context) async {
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
      initialDate: widget.selectedDate ?? todayDate(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate == null) return;
    widget.onDateChange(newDate);
  }
}
