import 'package:flutter/material.dart';

class DefaultHeader extends StatelessWidget {
  final VoidCallback? onPressMenu;
  final VoidCallback? onPressAdd;
  final double paddingHorizontal;

  const DefaultHeader({
    super.key,
    this.onPressMenu,
    this.onPressAdd,
    this.paddingHorizontal = 32,
  });

  static const borderWidth = 1.0;
  static const verticalPadding = 8.0;
  static const iconSize = 36.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: paddingHorizontal,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: borderWidth,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (onPressMenu != null)
            IconButton(
              icon: const Icon(Icons.menu),
              iconSize: iconSize,
              color: Theme.of(context).colorScheme.primary,
              onPressed: onPressMenu,
            )
          else
            const SizedBox(),
          if (onPressAdd != null)
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: iconSize,
              color: Theme.of(context).colorScheme.primary,
              onPressed: onPressAdd,
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
