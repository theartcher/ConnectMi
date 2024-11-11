import 'dart:convert';
import 'dart:ui';
import 'package:connect_mi/models/lamp_controls_params.dart';
import 'package:connect_mi/models/lamp_state.dart';
import 'package:connect_mi/utils/lamp_type_util.dart';
import 'package:connect_mi/utils/preferences_manager.dart';
import 'package:connect_mi/utils/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// The service to receive and control lamps.
class LampService {
  late final PreferencesManager prefMan;
  static const unsecuredBaseURL = "http://";
  static const timeoutDurationSeconds = 2;

  LampService() {
    prefMan = PreferencesManager();
  }

  Future<LampState> getCurrentState(LampControlParams params) async {
    var url = _buildUrl(params);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: timeoutDurationSeconds));

    _handleError(response);
    return LampState.fromJsonString(response.body);
  }

  Future<void> setColor(LampControlParams params, Color color) async {
    var body = {
      "color": "${color.red},${color.green},${color.blue}",
      "color_mode": "rgb"
    };

    await _updateState(body, params);
  }

  Future<void> setBrightness(LampControlParams params, num brightness) async {
    if (brightness < 0) {
      brightness = 0;
    }

    if (brightness > 255) {
      brightness = 255;
    }

    var body = {
      "brightness": "$brightness",
    };

    await _updateState(body, params);
  }

  Future<void> setSaturation(LampControlParams params, num saturation) async {
    if (saturation < 0) {
      saturation = 0;
    }

    if (saturation > 100) {
      saturation = 100;
    }

    var body = {
      "saturation": "$saturation",
    };

    await _updateState(body, params);
  }

  Future<void> toggleLamp(LampControlParams params, bool isEnabled) async {
    var body = {
      "state": "ON",
    };

    if (!isEnabled) {
      body = {"state": "OFF"};
    }

    await _updateState(body, params);
  }

  /// Handles making requests to the '/gateways/{deviceId}/{remoteType}/{groupId} url.
  Future<Response> _updateState(Object body, LampControlParams params) async {
    var url = _buildUrl(params);

    final response = await http
        .put(url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body))
        .timeout(const Duration(seconds: timeoutDurationSeconds));

    return _handleError(response);
  }

  /// Private method to construct the URL based on the provided parameters.
  Uri _buildUrl(LampControlParams params) {
    var endPoint =
        '/gateways/${params.deviceId}/${LampTypeUtils.getUrlFormat(params.type)}/${params.group.toString()}';
    var hubURL = prefMan.getMiLightHubUrl() + endPoint;
    return Uri.parse(unsecuredBaseURL + hubURL);
  }

  /// Private method to handle HTTP errors.
  Response _handleError(Response response) {
    if (response.statusCode == 200) return response;

    if (response.statusCode == 400) {
      SnackBarManager().snackTimed(
          "An error occurred performing this request, try restarting the app.",
          milliSecondsToShow: 2500,
          snackOption: SnackOptions.error);
    } else if (response.statusCode == 404) {
      SnackBarManager().snackTimed(
          "Could not reach MilightHub, check the URL in settings.",
          milliSecondsToShow: 2500,
          snackOption: SnackOptions.error);
    }

    return response;
  }
}
