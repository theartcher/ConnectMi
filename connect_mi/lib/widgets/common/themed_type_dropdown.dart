import 'package:flutter/material.dart';

class ThemedDropdown<T> extends StatelessWidget {
  final Function(T? value) onChange;
  final T? selectedValue;
  final List<T> options;
  final String hintLabel;
  final String Function(T) displayLabel;
  final bool isDisabled;

  const ThemedDropdown(
      {super.key,
      required this.onChange,
      required this.selectedValue,
      required this.options,
      required this.hintLabel,
      required this.displayLabel,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    final List<DropdownMenuItem<T>> dropdownItems = options
        .map((option) => DropdownMenuItem<T>(
              value: option,
              child: Text(displayLabel(option)),
            ))
        .toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        color: isDisabled
            ? colorTheme.secondary.withOpacity(0.5)
            : colorTheme.secondary,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      dropdownColor: isDisabled
                          ? colorTheme.onSurface.withOpacity(0.5)
                          : colorTheme.secondary,
                      value: selectedValue,
                      hint: Text(
                        hintLabel,
                        style: TextStyle(
                            color: isDisabled
                                ? colorTheme.onSurface.withOpacity(0.5)
                                : colorTheme.primary),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: isDisabled
                            ? colorTheme.onSurface.withOpacity(0.5)
                            : colorTheme.primary,
                      ),
                      style: TextStyle(
                          color: isDisabled
                              ? colorTheme.onSurface.withOpacity(0.5)
                              : colorTheme.primary),
                      onChanged: isDisabled
                          ? null
                          : (T? value) {
                              onChange(value);
                            },
                      items: isDisabled ? null : dropdownItems,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            color: isDisabled
                ? colorTheme.onSurface.withOpacity(0.5)
                : colorTheme.primary,
          ),
        ],
      ),
    );
  }
}
