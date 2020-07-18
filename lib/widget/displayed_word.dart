import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/widget/displayed_letter.dart';

// ignore: must_be_immutable
class DisplayedWord extends StatelessWidget {
  FlashcardInfo flashcardInfo;
  bool hasFurigana;
  DisplayedWord({this.flashcardInfo, this.hasFurigana});

  List<Widget> displayedLetterList = [];
  void updateDisplayedLetterList() {
    displayedLetterList.clear();
    for (int i = 0; i < flashcardInfo.word.length; i++) {
      bool isKanji = false;
      for (final kanji in flashcardInfo.kanji) {
        if (kanji.index == i) {
          isKanji = true;
          displayedLetterList.add(DisplayedLetter(
            hasFurigana: hasFurigana,
            letter: flashcardInfo.word[i],
            furigana: kanji.furigana,
          ));
        }
      }
      if (!isKanji) {
        displayedLetterList.add(DisplayedLetter(
          hasFurigana: hasFurigana,
          letter: flashcardInfo.word[i],
          furigana: '',
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    updateDisplayedLetterList();
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: displayedLetterList,
    );
  }
}
