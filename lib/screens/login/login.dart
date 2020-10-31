import 'package:flutter/material.dart';
import 'package:jp_flashcard/services/auth.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            RaisedButton(
              child: Text('login anon'),
              onPressed: () async {
                await Auth().signInAnon();
              },
            ),
            RaisedButton(
              child: Text('login google'),
              onPressed: () async {
                await Auth().signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
