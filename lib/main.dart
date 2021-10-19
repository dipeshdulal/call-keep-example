import 'package:call_keep_example/call.dart';
import 'package:call_keep_example/home.dart';
import 'package:call_keep_example/services/messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(Messaging.handleBackgroundMessage);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static pushNamed(String routeName, {Map<String, dynamic>? args}) {
    print(mainNavigatorKey.currentState);
    mainNavigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Navigator(
        key: mainNavigatorKey,
        initialRoute: "/home",
        onGenerateRoute: _onGenerateRoutes,
      ),
    );
  }

  Route? _onGenerateRoutes(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      if (settings.name == "/call") {
        return IncommingCall(args: settings.arguments as Map<String, dynamic>);
      }
      return HomePage();
    });
  }
}
