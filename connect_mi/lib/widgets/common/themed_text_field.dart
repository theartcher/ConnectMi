import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isDisabled;
  final Function(String value) onChanged;
  final Function(String value) onEditingComplete;

  const ThemedTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.onChanged,
    required this.onEditingComplete,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

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
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: TextStyle(
                        color: isDisabled
                            ? colorTheme.onSurface.withOpacity(0.5)
                            : colorTheme.primary,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: isDisabled
                              ? colorTheme.onSurface.withOpacity(0.5)
                              : colorTheme.primary,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: isDisabled ? null : onChanged,
                    onEditingComplete: () => onEditingComplete(controller.text),
                    enabled: !isDisabled,
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
