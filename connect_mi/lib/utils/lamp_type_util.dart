import 'package:connect_mi/models/lamp_group.dart';
import 'package:connect_mi/models/lamp_supported_modes.dart';
import 'package:connect_mi/models/lamp_type.dart';

class LampTypeUtils {
  static LampSupportedModes getSupportType(RemoteType type) {
    switch (type) {
      case RemoteType.RGB_CCT:
      case RemoteType.FUT089:
        return LampSupportedModes.cctRgb;

      case RemoteType.RGB:
      case RemoteType.RGBW:
      case RemoteType.FUT020:
        return LampSupportedModes.rgbOnly;

      case RemoteType.CCT:
      case RemoteType.FUT091:
        return LampSupportedModes.cctOnly;

      default:
        return LampSupportedModes.none;
    }
  }

  static LampGroup getGroupSize(RemoteType type) {
    switch (type) {
      case RemoteType.RGBW:
      case RemoteType.CCT:
      case RemoteType.RGB_CCT:
      case RemoteType.FUT091:
        return LampGroup.small;
      case RemoteType.FUT089:
        return LampGroup.large;
      default:
        return LampGroup.none;
    }
  }

  static String getUrlFormat(RemoteType type) {
    switch (type) {
      case RemoteType.RGBW:
        return 'rgbw';
      case RemoteType.CCT:
        return 'cct';
      case RemoteType.RGB_CCT:
        return 'rgb_cct';
      case RemoteType.RGB:
        return 'rgb';
      case RemoteType.FUT089:
        return 'fut089';
      case RemoteType.FUT091:
        return 'fut091';
      case RemoteType.FUT020:
        return 'fut020';
      default:
        return '';
    }
  }
}
