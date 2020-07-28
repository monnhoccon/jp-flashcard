import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/repo/edit_flashcard_page.dart';
import 'package:jp_flashcard/services/flashcard_manager.dart';
import 'package:jp_flashcard/services/text_to_speech.dart';
import 'package:jp_flashcard/components/displayed_word.dart';

// ignore: must_be_immutable
class DisplayedFlashcard extends StatefulWidget {
  int repoId;
  FlashcardInfo flashcardInfo;
  bool hasFurigana;
  Future<void> speakWord() async {
    await TextToSpeech.tts.speak('ja-JP', flashcardInfo.word);
    return;
  }

  Future<void> speakDefinition() async {
    for (final definition in flashcardInfo.definition) {
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
  DisplayedFlashcard({this.repoId, this.flashcardInfo, this.hasFurigana});
  _DisplayedFlashcardState createState() => _DisplayedFlashcardState();
}

class _DisplayedFlashcardState extends State<DisplayedFlashcard> {
  //ANCHOR Variables
  final Map _displayedStringZHTW = {
    'edit': '編輯',
    'delete': '刪除',
    'more': '更多',
    'delete flashcard alert title': '刪除單字卡',
    'delete flashcard alert content': '你確定要刪除此單字卡嗎？',
    'cancel': '取消',
    'confirm': '確認',
  };

  deleteAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        child: AlertDialog(
          title:
              Text(_displayedStringZHTW['delete flashcard alert title'] ?? ''),
          content: Text(
              _displayedStringZHTW['delete flashcard alert content'] ?? ''),
          contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(_displayedStringZHTW['cancel'] ?? '')),
            FlatButton(
                onPressed: () {
                  FlashcardManager.db(widget.repoId)
                      .deleteFlashcard(widget.flashcardInfo.flashcardId);
                  Navigator.of(context).pop(true);
                },
                child: Text(_displayedStringZHTW['confirm'] ?? ''))
          ],
        ));
  }

  List<Widget> displayedDefinitionList = [];
  List<Widget> displayedWordTypeList = [];

  void updateDisplayedDefinitionList() {
    displayedDefinitionList.clear();
    displayedDefinitionList.add(SizedBox(height: 10));
    int index = 1;
    for (final definition in widget.flashcardInfo.definition) {
      displayedDefinitionList.add(Flexible(
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 23, height: 1.5, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: (widget.flashcardInfo.definition.length != 1)
                    ? '$index. '
                    : '',
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
    for (final wordType in widget.flashcardInfo.wordType) {
      displayedWordTypeList.add(Text(
          (wordType != widget.flashcardInfo.wordType.last)
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
                    width: 350,
                    child: Column(
                      children: <Widget>[
                        //ANCHOR Setting button
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_horiz),
                                offset: Offset(0, 100),
                                tooltip: _displayedStringZHTW['more'] ?? '',
                                onSelected: (String result) async {
                                  if (result == 'edit') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return EditFlashcardPage(
                                        repoId: widget.repoId,
                                        flashcardInfo: widget.flashcardInfo,
                                      );
                                    })).then((newFlashcardInfo) {
                                      setState(() {
                                        widget.flashcardInfo = newFlashcardInfo;
                                      });
                                    });
                                  } else if (result == 'delete') {
                                    if (await deleteAlertDialog(context)) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text(
                                        _displayedStringZHTW['edit'] ?? ''),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text(
                                        _displayedStringZHTW['delete'] ?? ''),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        //ANCHOR Displayed word
                        Expanded(
                          child: DisplayedWord(
                            flashcardInfo: widget.flashcardInfo,
                            displayedWordSize: DisplayedWordSize.large(),
                          ),
                        ),

                        //ANCHOR Buttom action buttons
                        Divider(
                          thickness: 1,
                          indent: 30,
                          endIndent: 30,
                          color: Colors.grey[600],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.volume_up,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  widget.speakWord();
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  widget.flashcardInfo.favorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.flashcardInfo.favorite =
                                        !widget.flashcardInfo.favorite;
                                    FlashcardManager.db(widget.repoId)
                                        .updateFavorite(
                                      widget.flashcardInfo.flashcardId,
                                      widget.flashcardInfo.favorite,
                                    );
                                  });
                                },
                              )
                            ],
                          ),
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
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.center,
                                  runSpacing: 5,
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
                                  icon: Icon(
                                    Icons.volume_up,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    widget.speakDefinition();
                                  }),
                              IconButton(
                                icon: Icon(
                                  Icons.star_border,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  //TODO Favorite button
                                },
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
