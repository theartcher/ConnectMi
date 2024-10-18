import 'package:connect_mi/constants/routes.dart';
import 'package:connect_mi/utils/api/settings_service.dart';
import 'package:connect_mi/utils/preferences_manager.dart';
import 'package:connect_mi/utils/snackbar.dart';
import 'package:connect_mi/widgets/common/themed_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const double paddingBetweenItems = 24.00;
  late TextEditingController inputController;
  late SettingsService settingsService;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
    settingsService = SettingsService();
    _getInitialValue();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<void> _getInitialValue() async {
    var savedHubURL = PreferencesManager().getMiLightHubUrl();

    if (savedHubURL != "") {
      inputController.text = savedHubURL;
    }
  }

  String? get _errorText {
    final text = inputController.value.text;
    if (text.isEmpty) {
      final AppLocalizations textContent = AppLocalizations.of(context)!;
      return textContent.error_inputCantBeEmpty;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations textContent = AppLocalizations.of(context)!;

    Future<void> onPressContinue() async {
      setState(() {
        isLoading = true;
      });

      PreferencesManager().setMiLightHubUrl(inputController.text);
      bool isHubAccessible = await settingsService.testConnection();

      if (isHubAccessible) {
        context.push(remotePageRoute);
        SnackBarManager().clearAllSnacks();
      } else {
        SnackBarManager().snackDismissible(textContent.landing_failedToFindHub,
            snackOption: SnackOptions.error);
      }

      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(paddingBetweenItems),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row with title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(textContent.generic_connect,
                      style: textTheme.titleLarge),
                  Text(
                    textContent.generic_mi,
                    style: textTheme.titleLarge!
                        .copyWith(color: colorTheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: paddingBetweenItems),

              // Icon
              Icon(
                Icons.lightbulb_outline,
                color: colorTheme.primary,
                size: 150,
              ),
              const SizedBox(height: paddingBetweenItems),

              // Title and subtitle
              Column(
                children: [
                  Text(textContent.landing_title,
                      style: textTheme.headlineMedium),
                  const SizedBox(height: paddingBetweenItems / 2),
                  Text(
                    textContent.landing_subTitle,
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: paddingBetweenItems),

              // Input field and continue button
              ValueListenableBuilder(
                valueListenable: inputController,
                builder: (context, TextEditingValue value, __) {
                  return Column(
                    children: [
                      TextField(
                        controller: inputController,
                        style: TextStyle(color: colorTheme.primary),
                        decoration: InputDecoration(
                            fillColor: colorTheme.secondary,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText: textContent.generic_ipAddress,
                            labelStyle: TextStyle(
                                color: _errorText == null
                                    ? colorTheme.primary
                                    : colorTheme.error),
                            // The prefix is always this regardless of language, so it is irrelevant to add translations.
                            prefixText: 'http://',
                            prefixStyle: TextStyle(
                                color: colorTheme.onSurface.withOpacity(0.4)),
                            errorText: _errorText),
                        onChanged: (text) {
                          inputController.value = TextEditingValue(text: text);
                        },
                      ),
                      const SizedBox(height: paddingBetweenItems),
                      ThemedButton(
                        text: textContent.actions_continue,
                        isLoading: isLoading,
                        isDisabled: inputController.value.text.isEmpty,
                        onPress: () => onPressContinue(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
