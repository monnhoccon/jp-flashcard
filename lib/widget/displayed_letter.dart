import 'package:flutter/material.dart';

class DisplayedLetter extends StatelessWidget {
  final bool hasFurigana;
  final String letter;
  final String furigana;
  double furiganaFontSize = 15;
  double textFontSize = 35;
  DisplayedLetter({
    this.hasFurigana,
    this.letter,
    this.furigana,
    this.textFontSize,
    this.furiganaFontSize,
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
                  fontSize: furiganaFontSize,
                  height: 1.3,
                )
              : TextStyle(
                  fontSize: 0,
                  height: 0,
                  color: Colors.transparent,
                ),
        ),
        Text(
          letter,
          style: TextStyle(
            fontSize: textFontSize,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
