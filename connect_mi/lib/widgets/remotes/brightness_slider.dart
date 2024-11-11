import 'package:connect_mi/utils/api/lamp_service.dart';
import 'package:flutter/material.dart';

class BrightnessSlider extends StatefulWidget {
  final int initialValue;
  final int maxValue;
  final int minValue;
  final bool isDisabled;
  final bool showLabel;
  final Function(double brightness) setBrightness;

  const BrightnessSlider({
    super.key,
    this.initialValue = 0,
    this.maxValue = 100,
    this.minValue = 0,
    this.isDisabled = false,
    this.showLabel = false,
    required this.setBrightness,
  });

  @override
  _BrightnessSliderState createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider> {
  double _currentBrightness = 0;

  @override
  void didUpdateWidget(covariant BrightnessSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the brightness when the parent changes its value
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _currentBrightness = widget.initialValue.toDouble();
      });
    }
  }

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
          child: SliderTheme(
            data: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always),
            child: Slider(
              value: _currentBrightness,
              min: widget.minValue.toDouble(),
              max: widget.maxValue.toDouble(),
              label: _currentBrightness.round().toString(),
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
