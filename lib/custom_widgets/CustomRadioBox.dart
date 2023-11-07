import 'package:flutter/material.dart';

class CustomRadioBox extends StatefulWidget {
  final String title;
  final String value;
  final String? selectedValue;
  final Function(String) onChanged;

  CustomRadioBox({
    required this.title,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  _CustomRadioBoxState createState() => _CustomRadioBoxState();
}

class _CustomRadioBoxState extends State<CustomRadioBox> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(widget.title),
      value: widget.value,
      groupValue: widget.selectedValue,
      onChanged: (value) {
        setState(() {
          widget.onChanged(value!);
        });
      },
      activeColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}