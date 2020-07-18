import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/utils/text_to_speech.dart';
import 'package:jp_flashcard/widget/displayed_word.dart';

// ignore: must_be_immutable
class Flashcard extends StatefulWidget {
  FlashcardInfo info;
  Future<void> speakWord() async {
    await TextToSpeech.tts.speak('ja-JP', info.word);
    return;
  }

  Future<void> speakDefinition() async {
    for (final definition in info.definition) {
      await TextToSpeech.tts.speak('zh-TW', definition);
    }
    return;
  }

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  void flipPageToBack() {
    if (cardKey.currentState.isFront) {
      cardKey.currentState.toggleCard();
    }
  }

  void flipPageToFront() {
    if (!cardKey.currentState.isFront) {
      cardKey.currentState.toggleCard();
    }
  }

  @override
  Flashcard({this.info});
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  //ANCHOR Variables

  List<Widget> displayedDefinitionList = [];
  List<Widget> displayedWordTypeList = [];

  void updateDisplayedDefinitionList() {
    displayedDefinitionList.clear();
    displayedDefinitionList.add(SizedBox(height: 10));
    int index = 1;
    for (final definition in widget.info.definition) {
      displayedDefinitionList.add(Flexible(
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 23, height: 1.5, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: (widget.info.definition.length != 1) ? '$index. ' : '',
                style: TextStyle(
                    fontSize: 23, color: Colors.grey[500], height: 1.5),
              ),
              TextSpan(text: definition ?? ''),
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
    for (final wordType in widget.info.wordType) {
      displayedWordTypeList.add(Text((wordType != widget.info.wordType.last)
          ? (wordType + ' · ')
          : (wordType)));
    }
  }

  @override
  Widget build(BuildContext context) {
    updateDisplayedDefinitionList();
    updateDisplayedWordTypeList();
    return Center(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 450),
              child: FlipCard(
                key: widget.cardKey,
                front: Card(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    width: 350,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: DisplayedWord(
                            flashcardInfo: widget.info,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[600],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.volume_up),
                              onPressed: () {
                                widget.speakWord();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.star_border),
                              onPressed: () {},
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                back: Card(
                  child: Container(
                      padding: EdgeInsets.all(30),
                      width: 350,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  children: displayedWordTypeList,
                                ),
                                ...displayedDefinitionList,
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[600],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.volume_up),
                                  onPressed: () {
                                    widget.speakDefinition();
                                  }),
                              IconButton(
                                icon: Icon(Icons.star_border),
                                onPressed: () {},
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
            )),
      ),
    );
  }
}
