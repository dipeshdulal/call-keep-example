import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {
  Messaging._();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String?> requestPermissionAndGetToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      final String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<String> get deviceId async {
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }

    final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
    return androidInfo.androidId;
  }

  static Future<void> handleMessage(RemoteMessage message) async {
    log("got message: ");
    log(message.toString());
    log("data: ${message.data.toString()}");
  }
}
