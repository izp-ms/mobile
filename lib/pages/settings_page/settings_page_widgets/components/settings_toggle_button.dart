import 'package:flutter/material.dart';

class SettingsToggleButtons extends StatefulWidget {
  final void Function(int index) onSelected;

  SettingsToggleButtons({required this.onSelected});

  @override
  _SettingsToggleButtonsState createState() => _SettingsToggleButtonsState();
}

class _SettingsToggleButtonsState extends State<SettingsToggleButtons> {
  final List<bool> isSelected = [true, false];
  final List<String> labels = ['DD.MM.YYYY', 'MM.DD.YYYY'];

  Widget _buildChild(int index) {
    bool isIconFirst = index == 0;
    Color checkColor = isSelected[index]
        ? Theme.of(context).colorScheme.onPrimary
        : Colors.transparent;

    List<Widget> children = [
      if (isIconFirst) Icon(Icons.check, size: 18.0, color: checkColor),
      Text(labels[index]),
      if (!isIconFirst) Icon(Icons.check, size: 18.0, color: checkColor),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(30.0),
      borderColor: Colors.grey[500],
      selectedBorderColor: Colors.grey[500],
      fillColor: Theme.of(context).colorScheme.secondaryContainer,
      selectedColor: Theme.of(context).colorScheme.onPrimary,
      color: Theme.of(context).colorScheme.onPrimary,
      children:
      List<Widget>.generate(labels.length, (index) => _buildChild(index)),
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = (i == index);
          }
        });
        widget.onSelected(index);
      },
      isSelected: isSelected,
    );
  }
}
