import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  //ANCHOR Public variables
  final Function onPressed;
  final String displayedString;

  //ANCHOR Constructor
  SettingButton({this.displayedString, this.onPressed});

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Setting button
    return Container(
      height: 56,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: () {
                onPressed();
              },
              child: Row(
                children: <Widget>[
                  Text(
                    displayedString ?? '',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
