import 'package:flutter/material.dart';
import 'package:mobile/constants/ColorProvider.dart';

class SwitchWidget extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchWidget({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value,
      thumbIcon: thumbIcon,
      onChanged: widget.onChanged,
      activeColor: Theme.of(context).colorScheme.onError,
      activeTrackColor: Theme.of(context).colorScheme.secondaryContainer,
      inactiveThumbColor: ColorProvider.getColor('inactive'),
      trackOutlineColor: MaterialStateProperty.resolveWith(
        (final Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return null;
          }
          return ColorProvider.getColor('inactive');
        },
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.check,
          color: Color(0xFFA6ECFF),
        );
      }
      return Icon(Icons.close);
    },
  );
}
