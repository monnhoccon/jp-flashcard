import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/kanj_info.dart';
import 'package:jp_flashcard/widget/displayed_letter.dart';

// ignore: must_be_immutable
class Flashcard extends StatefulWidget {
  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  //ANCHOR Variables
  FlashcardInfo info = FlashcardInfo(word: '東京', definition: [
    'testing',
    '定義23'
  ], wordType: [
    '名詞',
    '形容詞',
  ], kanji: [
    KanjiInfo(index: 0, furigana: 'とう', length: 1),
    KanjiInfo(index: 1, furigana: 'きょう', length: 1)
  ]);

  List<Widget> displayedLetterList = [];
  List<Widget> displayedDefinitionList = [];
  List<Widget> displayedWordTypeList = [];

  void updateDisplayedLetterList() {
    displayedLetterList.clear();
    for (int i = 0; i < info.word.length; i++) {
      bool isKanji = false;
      for (final kanji in info.kanji) {
        if (kanji.index == i) {
          isKanji = true;
          displayedLetterList.add(DisplayedLetter(
            hasFurigana: true,
            letter: info.word[i],
            furigana: kanji.furigana,
          ));
        }
      }
      if (!isKanji) {
        displayedLetterList.add(DisplayedLetter(
          hasFurigana: false,
          letter: info.word[i],
          furigana: null,
        ));
      }
    }
  }

  void updateDisplayedDefinitionList() {
    displayedDefinitionList.clear();
    displayedDefinitionList.add(Divider(
      thickness: 1,
      color: Colors.grey[800],
    ));
    displayedDefinitionList.add(SizedBox(height: 10));
    int index = 1;
    for (final definition in info.definition) {
      displayedDefinitionList.add(Flexible(
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 23, height: 1.5, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: (info.definition.length != 1) ? '$index. ' : '',
                style: TextStyle(
                    fontSize: 23, color: Colors.grey[500], height: 1.5),
              ),
              TextSpan(text: definition),
            ],
          ),
        ),
      ));
      displayedDefinitionList.add(SizedBox(height: 15));
      index++;
    }
  }

  void updateDisplayedWordTypeList() {
    displayedWordTypeList.clear();
    for (final wordType in info.wordType) {
      displayedWordTypeList.add(Text(
          (wordType != info.wordType.last) ? (wordType + ' · ') : (wordType)));
    }
  }

  @override
  Widget build(BuildContext context) {
    updateDisplayedLetterList();
    updateDisplayedDefinitionList();
    updateDisplayedWordTypeList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 450),
                  child: FlipCard(
                    front: Card(
                      child: Container(
                          padding: EdgeInsets.all(30),
                          width: 350,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            children: displayedLetterList,
                          )),
                    ),
                    back: Card(
                      child: Container(
                          padding: EdgeInsets.all(50),
                          width: 350,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Wrap(
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                children: displayedWordTypeList,
                              ),
                              ...displayedDefinitionList,
                            ],
                          )),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
