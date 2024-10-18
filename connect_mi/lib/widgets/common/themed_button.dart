import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///A button themed using our local styling guidelines, with a loading indicator built into the button.
class ThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final bool isLoading;
  final bool isDisabled;

  const ThemedButton(
      {super.key,
      required this.text,
      required this.onPress,
      this.isLoading = false,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorTheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: isDisabled ? null : onPress,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDisabled
              ? colorTheme.onSurface.withOpacity(0.12)
              : colorTheme.primary,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
              text: TextSpan(text: text, style: textTheme.headlineSmall),
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            final textHeight = textPainter.size.height;

            return Row(
              children: [
                Expanded(
                  child: Center(
                    child: isLoading
                        ? SpinKitRing(
                            color: colorTheme.onPrimary,
                            size: textHeight,
                          )
                        : Text(
                            text,
                            style: textTheme.headlineSmall!.copyWith(
                              color: isDisabled
                                  ? colorTheme.onSurface.withOpacity(0.38)
                                  : colorTheme.onPrimary,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
