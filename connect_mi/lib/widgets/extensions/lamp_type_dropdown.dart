import 'package:connect_mi/widgets/common/themed_type_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:connect_mi/models/lamp_type.dart';

class LampTypeDropdown extends StatelessWidget {
  final Function(RemoteType type) onChangeType;
  final RemoteType selectedType;
  final bool isDisabled;

  const LampTypeDropdown(
      {super.key,
      required this.onChangeType,
      required this.selectedType,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return ThemedDropdown<RemoteType>(
      isDisabled: this.isDisabled,
      onChange: (value) {
        onChangeType(value ?? RemoteType.none);
      },
      selectedValue: selectedType == RemoteType.none ? null : selectedType,
      options:
          RemoteType.values.where((type) => type != RemoteType.none).toList(),
      hintLabel: 'Select Lamp Type',
      displayLabel: (type) => type.toString().split('.').last,
    );
  }
}
