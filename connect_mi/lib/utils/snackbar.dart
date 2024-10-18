import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'snackbar.dart';

/// The different options of snacks for the [SnackBarManager],
/// this involves the used colors to imply the type of behavior required.
enum SnackOptions { info, success, warn, error }

class SnackBarManager {
  // Singleton instance
  static final SnackBarManager _instance = SnackBarManager._internal();

  // Global key for the ScaffoldMessenger
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Private constructor
  SnackBarManager._internal();

  // Factory constructor for accessing the singleton instance
  factory SnackBarManager() {
    return _instance;
  }

  void clearAllSnacks() {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }

  /// Deploy a timed [SnackBar] without any actions.
  void snackTimed(String content,
      {SnackOptions snackOption = SnackOptions.info,
      int milliSecondsToShow = 1000}) {
    scaffoldMessengerKey.currentState?.clearSnackBars();

    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    switch (snackOption) {
      case SnackOptions.info:
        bgColor = Colors.transparent;
        textColor = Colors.white;
        break;
      case SnackOptions.success:
        bgColor = const Color(0xFFBFFFC6);
        textColor = Colors.black;
        break;
      case SnackOptions.warn:
        bgColor = const Color(0xFFE7FFAC);
        textColor = Colors.black;
        break;
      case SnackOptions.error:
        bgColor = const Color(0xFFFFABAB);
        textColor = Colors.black;
        break;
      default:
        bgColor = Colors.transparent;
        textColor = Colors.black;
        break;
    }

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(content, style: TextStyle(color: textColor)),
        duration: Duration(milliseconds: milliSecondsToShow),
        elevation: 0,
        backgroundColor: bgColor,
      ),
    );
  }

  /// Deploy a [SnackBar] with a 'dismiss' action.
  /// Will clear itself after 30 seconds.
  void snackDismissible(String content,
      {SnackOptions snackOption = SnackOptions.info}) {
    scaffoldMessengerKey.currentState?.clearSnackBars();

    // Assume AppLocalizations is set up correctly in your app
    final AppLocalizations textContent =
        AppLocalizations.of(scaffoldMessengerKey.currentContext!)!;
    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    switch (snackOption) {
      case SnackOptions.info:
        bgColor = Colors.transparent;
        textColor = Colors.white;
        break;
      case SnackOptions.success:
        bgColor = const Color(0xFFBFFFC6);
        textColor = Colors.black;
        break;
      case SnackOptions.warn:
        bgColor = const Color(0xFFE7FFAC);
        textColor = Colors.black;
        break;
      case SnackOptions.error:
        bgColor = const Color(0xFFFFABAB);
        textColor = Colors.black;
        break;
      default:
        bgColor = Colors.transparent;
        textColor = Colors.black;
        break;
    }

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(content, style: TextStyle(color: textColor)),
        action: SnackBarAction(
          label: textContent.actions_dismiss,
          textColor: textColor,
          onPressed: () {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
        duration: const Duration(seconds: 30),
        elevation: 0,
        backgroundColor: bgColor,
      ),
    );
  }
}
