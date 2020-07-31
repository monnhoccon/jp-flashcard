import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WordTypeBox extends StatefulWidget {
  final String displayedString;
  bool canSelect;
  bool selected = false;
  WordTypeBox({this.displayedString, this.canSelect, this.selected});

  @override
  _WordTypeBoxState createState() => _WordTypeBoxState();
}

class _WordTypeBoxState extends State<WordTypeBox> {
  Color backgroundColor = Colors.lightBlue[800];
  Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    if (!widget.selected && widget.canSelect) {
      backgroundColor = Colors.white;
      textColor = Colors.lightBlue[800];
    } else {
      backgroundColor = Colors.lightBlue[800];
      textColor = Colors.white;
    }
    return Container(
      height: 25,
      child: ButtonTheme(
        minWidth: 0.0,
        height: 28,
        child: FlatButton(
          onPressed: () {
            if (widget.canSelect) {
              setState(() {
                widget.selected = !widget.selected;
              });
            }
          },
          child: Text(widget.displayedString, style: TextStyle(color: textColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(width: 1.5, color: Colors.lightBlue[800]),
          ),
          color: backgroundColor,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ),
    );
  }
}
