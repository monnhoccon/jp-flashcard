import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/displaying_settings.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DisplayedLetter extends StatelessWidget {
  //ANCHOR Variables
  final String letter;
  final String furigana;
  DisplayingSettings _generalSettings;
  DisplayedWordSize _displayedWordSettings;

  //ANCHOR Constructor
  DisplayedLetter({
    this.letter,
    this.furigana,
  });

  //ANCHOR Initialize variables
  void initVariables(BuildContext context) {
    _generalSettings = Provider.of<DisplayingSettings>(context);
    _displayedWordSettings = Provider.of<DisplayedWordSize>(context);
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
          style: _generalSettings.hasFurigana
              ? TextStyle(
                  fontSize: _displayedWordSettings.furiganaFontSize,
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
            fontSize: _displayedWordSettings.textFontSize,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
