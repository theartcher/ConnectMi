import 'package:flutter/material.dart';

class LampToggle extends StatelessWidget {
  final Function(bool isEnabled) toggleLamp;
  final String labelOn;
  final String labelOff;
  final bool isDisabled;

  const LampToggle({
    super.key,
    required this.toggleLamp,
    required this.labelOn,
    required this.labelOff,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: ToggleButton(
            label: labelOn,
            backgroundColor: isDisabled
                ? colorTheme.primary.withOpacity(0.12)
                : colorTheme.primary,
            textColor: isDisabled
                ? colorTheme.onSurface.withOpacity(0.12)
                : colorTheme.onPrimary,
            onTap: isDisabled ? null : () => toggleLamp(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ToggleButton(
            label: labelOff,
            backgroundColor: isDisabled
                ? colorTheme.error.withOpacity(0.12)
                : colorTheme.error,
            textColor: isDisabled
                ? colorTheme.onError.withOpacity(0.12)
                : colorTheme.onError,
            onTap: isDisabled ? null : () => toggleLamp(false),
          ),
        ),
      ],
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const ToggleButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Center(
          child: Text(
            label,
            style: textTheme.headlineSmall!.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
