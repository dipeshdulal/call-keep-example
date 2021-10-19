import 'package:flutter/material.dart';

class IncommingCall extends StatelessWidget {
  const IncommingCall({Key? key, required this.args}) : super(key: key);

  final Map<String, dynamic> args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Text(
                "Call Accepted",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
              ),
            ),
            Text(
              "${args['handle'] ?? 'Unknown Caller'}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
