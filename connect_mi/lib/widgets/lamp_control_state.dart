import 'package:connect_mi/models/lamp_type.dart';
import 'package:flutter/material.dart';

class LampControlNotifier with ChangeNotifier {
  int brightness = 0;
  bool isLampOn = false;
  int deviceId = 0;
  RemoteType remoteType = RemoteType.none;
  int groupId = 0;

  // Method to set brightness
  void setBrightness(int newBrightness) {
    brightness = newBrightness;
    notifyListeners();
  }

  // Method to toggle the lamp state
  void toggleLamp(bool isOn) {
    isLampOn = isOn;
    notifyListeners();
  }

  // Method to set deviceId
  void setDeviceId(int newDeviceId) {
    deviceId = newDeviceId;
    notifyListeners();
  }

  // Method to set remoteType
  void setRemoteType(RemoteType newRemoteType) {
    remoteType = newRemoteType;
    notifyListeners();
  }

  // Method to set groupId
  void setGroupId(int newGroupId) {
    groupId = newGroupId;
    notifyListeners();
  }

  // Combined function for updating all the lamp control parameters at once (optional)
  void setLampControlParams(
      int newDeviceId, RemoteType newRemoteType, int newGroupId) {
    deviceId = newDeviceId;
    remoteType = newRemoteType;
    groupId = newGroupId;
    notifyListeners();
  }
}
