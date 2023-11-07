import 'package:flutter/material.dart';

import 'package:mobile/custom_widgets/CustomRadioBox.dart';

class SortDialog extends StatefulWidget {
  final String initialOrderBy;
  final Function(String) onApply;

  SortDialog({required this.initialOrderBy, required this.onApply});

  @override
  _SortDialogState createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  String selectedOrderBy = '';

  @override
  void initState() {
    super.initState();
    selectedOrderBy = widget.initialOrderBy;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sort By'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomRadioBox(
            title: 'Newest',
            value: 'date',
            selectedValue: selectedOrderBy,
            onChanged: (value) {
              setState(() {
                selectedOrderBy = value;
              });
            },
          ),
          CustomRadioBox(
            title: 'Oldest',
            value: '-date',
            selectedValue: selectedOrderBy,
            onChanged: (value) {
              setState(() {
                selectedOrderBy = value;
              });
            },
          ),
          CustomRadioBox(
            title: 'City A-Z',
            value: 'city',
            selectedValue: selectedOrderBy,
            onChanged: (value) {
              setState(() {
                selectedOrderBy = value;
              });
            },
          ),
          CustomRadioBox(
            title: 'City Z-A',
            value: '-city',
            selectedValue: selectedOrderBy,
            onChanged: (value) {
              setState(() {
                selectedOrderBy = value;
              });
            },
          ),
          CustomRadioBox(
            title: 'Country A-Z',
            value: 'country',
            selectedValue: selectedOrderBy,
            onChanged: (value) {
              setState(() {
                selectedOrderBy = value;
              });
            },
          ),
          CustomRadioBox(
            title: 'Country Z-A',
            value: '-country',
            selectedValue: selectedOrderBy,
            onChanged: (value) {
              setState(() {
                selectedOrderBy = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Cancel'),
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
          child: Text('Apply'),
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
            if (selectedOrderBy != widget.initialOrderBy) {
              widget.onApply(selectedOrderBy);
            }
          },
        ),
      ],
    );
  }
}