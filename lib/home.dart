import 'dart:async';
import 'dart:developer';

import 'package:call_keep_example/services/messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<RemoteMessage>? _$message;

  _HomePageState() {
    _init();
  }

  _init() async {
    String? token = await Messaging.requestPermissionAndGetToken();
    String? uid = await Messaging.deviceId;
    log("token: $token");
    log("uid: $uid");
  }

  @override
  void initState() {
    _$message = FirebaseMessaging.onMessage.listen(Messaging.handleMessage);
    super.initState();
  }

  @override
  void dispose() {
    _$message?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("home page"),
      ),
    );
  }
}
