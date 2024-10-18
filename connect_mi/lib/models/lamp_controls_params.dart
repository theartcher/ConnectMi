import 'package:connect_mi/models/lamp_type.dart';

class LampControlParams {
  int deviceId;
  RemoteType type;
  int group;

  LampControlParams({
    required this.deviceId,
    required this.type,
    required this.group,
  });
}
