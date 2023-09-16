import 'package:flutter/material.dart';
import 'package:mobile/helpers/todaysDate.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChange;

  const CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChange,
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
    return (selectedDate == todayDate())
        ? "Birthday"
        : "${selectedDate.day}.${selectedDate.month}.${selectedDate.year}";
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
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate == null) return;
    onDateChange(newDate);
  }
}
