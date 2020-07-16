import 'package:flutter/material.dart';

class DisplayedLetter extends StatelessWidget {
  final bool hasFurigana;
  final String letter;
  final String furigana;
  DisplayedLetter({
    this.hasFurigana,
    this.letter,
    this.furigana,
  });

  @override
  Widget build(BuildContext context) {
    if (hasFurigana) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(furigana),
          Text(
            letter,
            style: TextStyle(fontSize: 35, height: 1.2),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'あ',
            style: TextStyle(color: Colors.transparent),
          ),
          Text(
            letter,
            style: TextStyle(fontSize: 35, height: 1.2),
          ),
        ],
      );
    }
  }
}
