import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/word_displaying_settings.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DisplayedLetter extends StatelessWidget {
  //ANCHOR Variables
  final String letter;
  final String furigana;
  WordDisplayingSettings _displayingSettings;
  DisplayedWordSize _displayedWordSize;

  //ANCHOR Constructor
  DisplayedLetter({
    this.letter,
    this.furigana,
  });

  //ANCHOR Initialize variables
  void initVariables(BuildContext context) {
    _displayingSettings = Provider.of<WordDisplayingSettings>(context);
    _displayedWordSize = Provider.of<DisplayedWordSize>(context);
  }

  @override
  Widget build(BuildContext context) {
    //ANCHOR Initialize
    initVariables(context);

    //ANCHOR Displayed letter widget
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //ANCHOR Furigana text
        Text(
          furigana,
          style: _displayingSettings.hasFurigana && furigana != ''
              ? TextStyle(
                  fontSize: _displayedWordSize.furiganaFontSize,
                  height: 1.3,
                )
              : TextStyle(
                  fontSize: 0,
                  height: 0,
                  color: Colors.transparent,
                ),
        ),

        //ANCHOR Letter text
        Text(
          letter,
          style: TextStyle(
            fontSize: _displayedWordSize.textFontSize,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
