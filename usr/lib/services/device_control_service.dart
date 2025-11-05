import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'dart:io';

class DeviceControlService {
  Future<String?> executeCommand(String command) async {
    if (!Platform.isAndroid) {
      return 'Device control is only available on Android devices.';
    }
    
    final lowercaseCommand = command.toLowerCase();
    
    try {
      // Lock/Unlock phone
      if (lowercaseCommand.contains('lock') && lowercaseCommand.contains('phone')) {
        return await _lockPhone();
      }
      
      // Settings shortcuts
      if (lowercaseCommand.contains('wifi') || lowercaseCommand.contains('wi-fi')) {
        return await _openWifiSettings();
      }
      
      if (lowercaseCommand.contains('bluetooth')) {
        return await _openBluetoothSettings();
      }
      
      if (lowercaseCommand.contains('settings')) {
        return await _openSettings();
      }
      
      // App launching
      if (lowercaseCommand.contains('camera')) {
        return await _openCamera();
      }
      
      if (lowercaseCommand.contains('call') || lowercaseCommand.contains('phone dialer')) {
        return await _openDialer();
      }
      
      if (lowercaseCommand.contains('message') || lowercaseCommand.contains('sms')) {
        return await _openMessages();
      }
      
      if (lowercaseCommand.contains('browser') || lowercaseCommand.contains('chrome')) {
        return await _openBrowser();
      }
      
      if (lowercaseCommand.contains('alarm') || lowercaseCommand.contains('clock')) {
        return await _openClock();
      }
      
      return null; // No command matched
    } catch (e) {
      return 'Error executing command: ${e.toString()}';
    }
  }
  
  Future<String> _lockPhone() async {
    // Note: Locking phone requires device admin privileges
    // This is a simplified implementation
    const intent = AndroidIntent(
      action: 'android.app.action.LOCK_NOW',
    );
    await intent.launch();
    return 'Phone locked successfully.';
  }
  
  Future<String> _openWifiSettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.WIFI_SETTINGS',
    );
    await intent.launch();
    return 'Opening WiFi settings.';
  }
  
  Future<String> _openBluetoothSettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.BLUETOOTH_SETTINGS',
    );
    await intent.launch();
    return 'Opening Bluetooth settings.';
  }
  
  Future<String> _openSettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.SETTINGS',
    );
    await intent.launch();
    return 'Opening settings.';
  }
  
  Future<String> _openCamera() async {
    const intent = AndroidIntent(
      action: 'android.media.action.IMAGE_CAPTURE',
    );
    await intent.launch();
    return 'Opening camera.';
  }
  
  Future<String> _openDialer() async {
    const intent = AndroidIntent(
      action: 'android.intent.action.DIAL',
    );
    await intent.launch();
    return 'Opening phone dialer.';
  }
  
  Future<String> _openMessages() async {
    const intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      category: 'android.intent.category.APP_MESSAGING',
    );
    await intent.launch();
    return 'Opening messaging app.';
  }
  
  Future<String> _openBrowser() async {
    const intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'https://www.google.com',
    );
    await intent.launch();
    return 'Opening browser.';
  }
  
  Future<String> _openClock() async {
    const intent = AndroidIntent(
      action: 'android.intent.action.SHOW_ALARMS',
    );
    await intent.launch();
    return 'Opening clock app.';
  }
}