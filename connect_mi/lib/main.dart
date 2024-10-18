import 'package:connect_mi/constants/routes.dart';
import 'package:connect_mi/constants/themes.dart';
import 'package:connect_mi/utils/preferences_manager.dart';
import 'package:connect_mi/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager.initialize();

  runApp(MainApp(
    themeMode: PreferencesManager().getTheme(),
    locale: PreferencesManager().getLocale(),
  ));
}

class MainApp extends StatefulWidget {
  final ThemeMode themeMode;
  final Locale locale;

  const MainApp({super.key, required this.themeMode, required this.locale});

  @override
  State<MainApp> createState() => MainAppState();

  static MainAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MainAppState>()!;
}

class MainAppState extends State<MainApp> {
  late Locale _locale;
  late ThemeMode _themeMode;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    super.initState();
    _themeMode = widget.themeMode;
    _locale = widget.locale;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: _locale,
      scaffoldMessengerKey: SnackBarManager.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en', 'US'),
      ],
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
}
