import 'package:flutter/material.dart';
import 'package:gradient_slider/gradient_slider.dart';

class SaturationSlider extends StatefulWidget {
  final int initialValue;
  final int maxValue;
  final int minValue;
  final bool isDisabled;
  final bool showLabel;
  final Function(double saturation) setSaturation;
  final Color baseColor;

  const SaturationSlider({
    super.key,
    this.initialValue = 100,
    this.maxValue = 100,
    this.minValue = 0,
    this.isDisabled = false,
    this.showLabel = false,
    required this.setSaturation,
    required this.baseColor,
  });

  @override
  _SaturationSliderState createState() => _SaturationSliderState();
}

class _SaturationSliderState extends State<SaturationSlider> {
  double _currentSaturation = 100;

  @override
  void didUpdateWidget(covariant SaturationSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the saturation when the parent changes its value
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _currentSaturation = widget.initialValue.toDouble();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSaturation = widget.initialValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GradientSlider(
            thumbAsset: '',
            activeTrackGradient: LinearGradient(
              colors: [
                HSVColor.fromAHSV(
                        1.0, HSVColor.fromColor(widget.baseColor).hue, 0.0, 1.0)
                    .toColor(), // 0% saturation
                widget.baseColor, // 100% saturation
              ],
            ),
            inactiveTrackGradient: LinearGradient(
              colors: [
                HSVColor.fromAHSV(
                        1.0, HSVColor.fromColor(widget.baseColor).hue, 0.0, 1.0)
                    .toColor(), // 0% saturation
                widget.baseColor, // 100% saturation
              ],
            ),
            inactiveTrackColor: Colors.black,
            slider: Slider(
              value: widget.initialValue.toDouble(),
              min: widget.minValue.toDouble(),
              max: widget.maxValue.toDouble(),
              onChanged: widget.isDisabled
                  ? null
                  : (double value) {
                      setState(() {
                        _currentSaturation = value;
                      });
                    },
              onChangeEnd: (double value) {
                setState(() {
                  widget.setSaturation(_currentSaturation);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
