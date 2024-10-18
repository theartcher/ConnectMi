import 'dart:convert';

import 'package:connect_mi/models/lamp_controls_params.dart';
import 'package:connect_mi/models/lamp_type.dart';
import 'package:connect_mi/utils/lamp_type_util.dart';
import 'package:connect_mi/utils/preferences_manager.dart';
import 'package:connect_mi/utils/snackbar.dart';
import 'package:http/http.dart' as http;

/// The service to receive and control lamps.
class LampService {
  late final PreferencesManager prefMan;
  static const unsecuredBaseURL = "http://";
  static const timeoutDurationSeconds = 2;

  LampService() {
    prefMan = PreferencesManager();
  }

  Future<void> setBrightness(LampControlParams params, num brightness) async {
    if (brightness < 0) {
      brightness = 0;
    }

    if (brightness > 100) {
      brightness = 100;
    }

    var body = {
      "level": "${brightness}",
    };

    _handleRequest(body, params);
  }

  Future<void> toggleLamp(LampControlParams params, bool isEnabled) async {
    var body = {
      "state": "ON",
    };

    if (!isEnabled) {
      body = {"state": "OFF"};
    }

    _handleRequest(body, params);
  }

  /// Handles making requests to the '/gateways/{deviceId}/{remoteType}/{groupId} url.
  Future<void> _handleRequest(Object body, LampControlParams params) async {
    var endPoint =
        '/gateways/${params.deviceId}/${LampTypeUtils.getUrlFormat(params.type)}/${params.group.toString()}';
    var hubURL = prefMan.getMiLightHubUrl() + endPoint;
    var url = Uri.parse(unsecuredBaseURL + hubURL);

    final response = await http
        .put(url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body))
        .timeout(const Duration(seconds: timeoutDurationSeconds));

    if (response.statusCode == 200) return;
    if (response.statusCode == 400) {
      SnackBarManager().snackTimed(
          "An error occurred performing this request, try restarting the app.",
          milliSecondsToShow: 2500,
          snackOption: SnackOptions.error);
      return;
    }

    if (response.statusCode == 404) {
      SnackBarManager().snackTimed(
          "Could not reach MilightHub, check the URL in settings.",
          milliSecondsToShow: 2500,
          snackOption: SnackOptions.error);
      return;
    }
  }
}
