import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/components/displayed_letter.dart';
import 'package:jp_flashcard/models/word_displaying_settings.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DisplayedWord extends StatelessWidget {
  //ANCHOR Variables
  FlashcardInfo flashcardInfo;
  DisplayedWordSize displayedWordSize;

  //ANCHOR Constructor
  DisplayedWord({
    this.flashcardInfo,
    this.displayedWordSize,
  });

  //ANCHOR Initialize displayed letter list
  List<Widget> _displayedLetterList = [];
  void initDisplayedLetterList() {
    _displayedLetterList.clear();
    for (int i = 0; i < flashcardInfo.word.length; i++) {
      bool isKanji = false;
      for (final kanji in flashcardInfo.kanji) {
        if (kanji.index == i) {
          isKanji = true;
          if (_hasKanji) {
            _displayedLetterList.add(DisplayedLetter(
              letter: flashcardInfo.word[i],
              furigana: kanji.furigana,
            ));
          } else {
            for (int j = 0; j < kanji.furigana.length; j++)
              _displayedLetterList.add(DisplayedLetter(
                letter: kanji.furigana[j],
                furigana: '',
              ));
          }
        }
      }
      if (!isKanji) {
        _displayedLetterList.add(DisplayedLetter(
          letter: flashcardInfo.word[i],
          furigana: '',
        ));
      }
    }
  }

  //ANCHOR Initialize variables
  bool _hasKanji;
  void initVariables(BuildContext context) {
    _hasKanji = Provider.of<WordDisplayingSettings>(context).hasKanji;
  }

  @override
  Widget build(BuildContext context) {
    //ANCHOR Initialize
    initVariables(context);
    initDisplayedLetterList();

    //ANCHOR Displayed word widget
    return Provider<DisplayedWordSize>(
      create: (context) {
        return displayedWordSize;
      },
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        children: _displayedLetterList,
      ),
    );
  }
}
