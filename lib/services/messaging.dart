import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:call_keep_example/main.dart';
import 'package:callkeep/callkeep.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';

final FlutterCallkeep callKeep = FlutterCallkeep();
bool _callKeepInitialized = false;

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

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    try {
      final callerName = "Dipesh Dulal [CallKeep]";
      final callUUID = Uuid().v4();
      log("got background message: ${message.data.toString()}");
      callKeep.on(
        CallKeepPerformAnswerCallAction(),
        (CallKeepPerformAnswerCallAction event) async {
          await callKeep.endCall(event.callUUID ?? "");
          await callKeep.backToForeground();
          Timer(Duration(seconds: 1), () {
            MyApp.pushNamed("/call", args: {
              "calluuid": callUUID,
              "handle": callerName,
            });
          });
        },
      );

      callKeep.on(CallKeepPerformEndCallAction(), (event) {
        log("[EndCallActionEvent]");
      });

      if (!_callKeepInitialized) {
        callKeep.setup(
          null,
          <String, dynamic>{
            'ios': {
              'appName': 'CallKeepDemo',
            },
            'android': {
              'alertTitle': 'Permissions required',
              'alertDescription':
                  'This application needs to access your phone accounts',
              'cancelButton': 'Cancel',
              'okButton': 'ok',
              'foregroundService': {
                'channelId': 'com.company.my',
                'channelName': 'Foreground service for my app',
                'notificationTitle': 'My app is running on background',
                'notificationIcon':
                    'Path to the resource icon of the notification',
              },
            },
          },
          backgroundMode: true,
        );
        _callKeepInitialized = true;
      }

      log("background message: [display incomming call]");
      callKeep.displayIncomingCall(
        callUUID,
        callerName,
        hasVideo: true,
      );
      callKeep.backToForeground();
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> handleMessage(RemoteMessage message) async {
    log("got message: ");
    log(message.toString());
    log("data: ${message.data.toString()}");
  }
}
