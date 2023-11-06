import 'package:flutter/material.dart';
import 'package:mobile/constants/ColorProvider.dart';

class SettingsToggleButtons extends StatefulWidget {
  final void Function(int index) onSelected;
  final int initialSelectedIndex;

  SettingsToggleButtons({
    required this.onSelected,
    required this.initialSelectedIndex
  });

  @override
  _SettingsToggleButtonsState createState() => _SettingsToggleButtonsState();
}

class _SettingsToggleButtonsState extends State<SettingsToggleButtons> {
  late List<bool> isSelected;
  final labels = ['DD.MM.YYYY', 'MM.DD.YYYY'];

  @override
  void initState() {
    super.initState();
    isSelected = List.generate(2, (index) => index == widget.initialSelectedIndex);
  }

  Widget _buildChild(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (index == 0) _checkIcon(index),
          Text(labels[index]),
          if (index == 1) _checkIcon(index),
        ],
      ),
    );
  }

  Icon _checkIcon(int index) {
    return Icon(
      Icons.check,
      size: 18.0,
      color: isSelected[index] ? Theme.of(context).colorScheme.onPrimary : Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(30.0),
      borderColor: ColorProvider.getColor('inactive'),
      selectedBorderColor: ColorProvider.getColor('inactive'),
      fillColor: Theme.of(context).colorScheme.secondaryContainer,
      selectedColor: Theme.of(context).colorScheme.onPrimary,
      color: Theme.of(context).colorScheme.onPrimary,
      children: List.generate(labels.length, _buildChild),
      onPressed: (index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
        });
        widget.onSelected(index);
      },
      isSelected: isSelected,
    );
  }
}