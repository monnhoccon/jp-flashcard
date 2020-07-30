import 'package:flutter/material.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class TagBoxButton extends StatelessWidget {
  //ANCHOR Public variables
  final Function onPressed;

  //ANCHOR Constructor
  TagBoxButton({this.onPressed});

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: ButtonTheme(
        minWidth: 5.0,
        height: 28.0,
        child: FlatButton(
          onPressed: () {
            onPressed();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add, size: 15, color: Colors.white),
              SizedBox(width: 2),
              Text(
                DisplayedString.zhtw['add tags'] ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
