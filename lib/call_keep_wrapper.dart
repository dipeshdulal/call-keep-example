import 'package:call_keep_example/main.dart';
import 'package:call_keep_example/services/messaging.dart';
import 'package:callkeep/callkeep.dart';
import 'package:flutter/material.dart';

class CallkeepWrapper extends StatefulWidget {
  const CallkeepWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _CallkeepWrapperState createState() => _CallkeepWrapperState();
}

class _CallkeepWrapperState extends State<CallkeepWrapper> {
  @override
  void initState() {
    _setup();
    super.initState();
  }

  void _setup() {
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
            'notificationIcon': 'Path to the resource icon of the notification',
          },
        },
      },
      backgroundMode: true,
    );

    callKeep.on(CallKeepPerformAnswerCallAction(),
        (CallKeepPerformAnswerCallAction event) {
      print("call answer action performed got from wrapper");
      callKeep.setCurrentCallActive(event.callUUID ?? "");
      MyApp.pushNamed("/call", args: <String, dynamic>{
        "handle": event.callUUID,
      });
    });

    callKeep.on(CallKeepPerformEndCallAction(),
        (CallKeepPerformEndCallAction event) {
      print("call answer action performed got from wrapper");
      callKeep.endCall(event.callUUID ?? "");
      MyApp.pushNamed("/home");
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
