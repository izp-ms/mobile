import 'package:flutter/material.dart';
import 'package:mobile/constants/ColorProvider.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
    required this.notificationRangeValue,
    required this.onValueChange,
    required this.divisions,
    required this.minimum,
    required this.maximum,
    this.showValueIndicator = false,
  });

  final double notificationRangeValue;
  final ValueChanged<double> onValueChange;
  final int divisions;
  final double minimum;
  final double maximum;
  final bool showValueIndicator;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 12.0,
        trackShape: const RoundedRectSliderTrackShape(),
        activeTrackColor: Theme.of(context).colorScheme.secondaryContainer,
        inactiveTrackColor: ColorProvider.getColor('inactive'),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 14.0,
          pressedElevation: 8.0,
        ),
        thumbColor: Theme.of(context).colorScheme.secondaryContainer,
        overlayColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
        overlayShape: SliderComponentShape.noOverlay,
        tickMarkShape: const RoundSliderTickMarkShape(),
        activeTickMarkColor: Theme.of(context).colorScheme.secondaryContainer,
        inactiveTickMarkColor: Colors.white,
        valueIndicatorShape: showValueIndicator
            ? const PaddleSliderValueIndicatorShape()
            : SliderComponentShape.noOverlay,
        valueIndicatorColor: ColorProvider.getColor('inactive'),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      child: Slider(
        min: minimum,
        max: maximum,
        value: notificationRangeValue,
        divisions: divisions,
        label: '${notificationRangeValue.round()}',
        onChanged: (value) {
          onValueChange(value);
        },
      ),
    );
  }
}
