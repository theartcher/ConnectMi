import 'package:connect_mi/utils/api/lamp_service.dart';
import 'package:flutter/material.dart';

class LampBrightnessSlider extends StatefulWidget {
  final int initialValue;
  final int maxValue;
  final int minValue;
  final bool isDisabled;
  final Function(double brightness) setBrightness;

  const LampBrightnessSlider({
    super.key,
    this.initialValue = 0,
    this.maxValue = 100,
    this.minValue = 0,
    this.isDisabled = false,
    required this.setBrightness,
  });

  @override
  _LampBrightnessSliderState createState() => _LampBrightnessSliderState();
}

class _LampBrightnessSliderState extends State<LampBrightnessSlider> {
  double _currentBrightness = 0;

  @override
  void initState() {
    super.initState();
    _currentBrightness = widget.initialValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lightbulb_outline,
            size: 24,
            color: widget.isDisabled
                ? colorTheme.onSurface.withOpacity(0.12)
                : colorTheme.onSurface),
        Expanded(
          child: Slider(
            value: _currentBrightness,
            min: widget.minValue.toDouble(),
            max: widget.maxValue.toDouble(),
            label: '${_currentBrightness.round()}',
            inactiveColor: colorTheme.primary.withOpacity(0.3),
            onChanged: widget.isDisabled
                ? null
                : (double value) {
                    setState(() {
                      _currentBrightness = value;
                    });
                  },
            onChangeEnd: (double value) {
              setState(() {
                widget.setBrightness(_currentBrightness);
              });
            },
          ),
        ),
        Icon(Icons.lightbulb,
            size: 36,
            color: widget.isDisabled
                ? colorTheme.onSurface.withOpacity(0.12)
                : colorTheme.onSurface),
      ],
    );
  }
}
