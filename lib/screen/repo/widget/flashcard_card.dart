import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screen/repo/edit_flashcard_page.dart';
import 'package:jp_flashcard/utils/database.dart';
import 'package:jp_flashcard/utils/text_to_speech.dart';
import 'package:jp_flashcard/widget/displayed_word.dart';

// ignore: must_be_immutable
class FlashcardCard extends StatelessWidget {
  int repoId;
  int flashcardCardIndex;
  FlashcardInfo flashcardInfo;
  bool hasFurigana;
  Function navigateToFlashcard;
  Function rebuildFlashcardMenu;
  @override
  FlashcardCard({
    this.repoId,
    this.flashcardInfo,
    this.flashcardCardIndex,
    this.navigateToFlashcard,
    this.hasFurigana,
    this.rebuildFlashcardMenu,
  });
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
                  DBManager.db
                      .deleteFlashcard(repoId, flashcardInfo.flashcardId);
                  Navigator.of(context).pop(true);
                },
                child: Text(_displayedStringZHTW['confirm'] ?? ''))
          ],
        ));
  }

  List<Widget> displayedDefinitionList = [];
  void initDisplayedDefinitionList() {
    displayedDefinitionList.clear();
    int i = 1;
    for (final definition in flashcardInfo.definition) {
      displayedDefinitionList.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Text(
          flashcardInfo.definition.length > 1
              ? '$i. ' + definition
              : definition,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ));
      i++;
    }
    
  }
  //TODO Width overflow
  
  Future<void> speak() async {
    await TextToSpeech.tts.speak('ja-JP', flashcardInfo.word);
    for (final definition in flashcardInfo.definition) {
      await TextToSpeech.tts.speak('zh-TW', definition);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    initDisplayedDefinitionList();
    return Container(
      padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(5),
          onTap: () {
            navigateToFlashcard(flashcardCardIndex);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 12, 0, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DisplayedWord(
                      flashcardInfo: flashcardInfo,
                      hasFurigana: hasFurigana,
                      textFontSize: 21,
                      furiganaFontSize: 9,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ...displayedDefinitionList,
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.volume_up,
                          size: 23.0,
                        ),
                        onPressed: () {
                          speak();
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.star_border,
                        size: 23.0,
                      ),
                      onPressed: () {
                        //TODO Favorite button
                      },
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      offset: Offset(0, 100),
                      tooltip: _displayedStringZHTW['more'] ?? '',
                      onSelected: (String result) async {
                        if (result == 'edit') {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return EditFlashcardPage(
                              repoId: repoId,
                              flashcardInfo: flashcardInfo,
                            );
                          })).then((newFlashcardInfo) {
                            rebuildFlashcardMenu();
                          });
                        } else if (result == 'delete') {
                          if (await deleteAlertDialog(context)) {
                            rebuildFlashcardMenu();
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text(_displayedStringZHTW['edit'] ?? ''),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(_displayedStringZHTW['delete'] ?? ''),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
