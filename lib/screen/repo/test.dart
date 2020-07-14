import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  Function pressed;
  Test({this.pressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
          onPressed: () {
            pressed('b');
          },
          child: Icon(Icons.access_time)),
    );
  }
}
