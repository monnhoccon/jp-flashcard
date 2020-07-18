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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          furigana,
          style: hasFurigana
              ? TextStyle(
                  fontSize: 15,
                  height: 1.3,
                )
              : TextStyle(
                  fontSize: 15,
                  height: 0,
                  color: Colors.transparent,
                ),
        ),
        Text(
          letter,
          style: TextStyle(fontSize: 35, height: 1.2),
        ),
      ],
    );
  }
}
