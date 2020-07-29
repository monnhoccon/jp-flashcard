import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  //ANCHOR Public variables
  final String displayingString;
  final Function onPressed;

  //ANCHOR Constructor
  ActionButton({this.displayingString, this.onPressed});

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Action button
    return ButtonTheme(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      minWidth: 0,
      height: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: FlatButton(
        onPressed: () {
          onPressed(context);
        },
        child: Text(
          displayingString,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
