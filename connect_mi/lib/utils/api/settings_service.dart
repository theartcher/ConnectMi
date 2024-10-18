import 'package:connect_mi/utils/preferences_manager.dart';
import 'package:http/http.dart' as http;

/// The service to retrieve and set settings of the MiLight-hub.
class SettingsService {
  late final PreferencesManager prefMan;
  static const unsecuredBaseURL = "http://";

  SettingsService() {
    _initializePreferencesManager();
  }

  void _initializePreferencesManager() async {
    await PreferencesManager.initialize();
    prefMan = PreferencesManager();
  }

  /// Retrieves the saved local URL and attempts to connect. Will return true if succeeded, otherwise returns false.
  Future<bool> testConnection() async {
    var hubURL = prefMan.getMiLightHubUrl();
    var systemInfoEndpoint = "/about";

    try {
      final response = await http
          .get(Uri.parse(unsecuredBaseURL + hubURL + systemInfoEndpoint))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      return false;
    }

    return false;
  }
}
