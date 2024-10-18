import 'package:connect_mi/widgets/common/themed_type_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:connect_mi/models/lamp_group.dart';

class LampGroupDropdown extends StatelessWidget {
  final Function(int value) onChangeValue;
  final LampGroup selectedGroup;
  final int selectedValue;
  final bool isDisabled;

  const LampGroupDropdown(
      {super.key,
      required this.onChangeValue,
      required this.selectedGroup,
      required this.selectedValue,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    // Determine the numeric range based on the selected group
    List<int> options = [];
    switch (selectedGroup) {
      case LampGroup.small:
        options = List.generate(5, (index) => index); // 0 -> 4
        break;
      case LampGroup.large:
        options = List.generate(9, (index) => index); // 0 -> 8
        break;
      default:
        options = [0]; // Only 'ALL' for 'none'
        break;
    }

    return ThemedDropdown<int>(
      isDisabled: this.isDisabled,
      onChange: (value) {
        onChangeValue(value ?? 0); // Default to 0 if value is null
      },
      selectedValue: selectedValue,
      options: options,
      hintLabel: 'Select group',
      displayLabel: (value) => value == 0 ? 'ALL' : value.toString(),
    );
  }
}
