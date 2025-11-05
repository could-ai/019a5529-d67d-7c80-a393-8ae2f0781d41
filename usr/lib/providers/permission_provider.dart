import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider extends ChangeNotifier {
  bool _microphoneGranted = false;
  bool _deviceAdminGranted = false;
  bool _hasCheckedPermissions = false;
  
  bool get microphoneGranted => _microphoneGranted;
  bool get deviceAdminGranted => _deviceAdminGranted;
  bool get hasCheckedPermissions => _hasCheckedPermissions;
  bool get allPermissionsGranted => _microphoneGranted && _deviceAdminGranted;
  
  Future<void> checkPermissions() async {
    _microphoneGranted = await Permission.microphone.isGranted;
    _deviceAdminGranted = await Permission.systemAlertWindow.isGranted;
    _hasCheckedPermissions = true;
    notifyListeners();
  }
  
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    _microphoneGranted = status.isGranted;
    notifyListeners();
    return _microphoneGranted;
  }
  
  Future<bool> requestDeviceAdminPermission() async {
    final status = await Permission.systemAlertWindow.request();
    _deviceAdminGranted = status.isGranted;
    notifyListeners();
    return _deviceAdminGranted;
  }
  
  Future<bool> requestAllPermissions() async {
    await requestMicrophonePermission();
    await requestDeviceAdminPermission();
    return allPermissionsGranted;
  }
}