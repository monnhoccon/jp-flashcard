import 'package:flutter/material.dart';
import 'package:jp_flashcard/dialogs/reset_progress_dialog.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/services/managers/flashcard_manager.dart';
import 'package:jp_flashcard/models/word_displaying_settings.dart';
import 'package:jp_flashcard/screens/flashcard_page/flashcard_page.dart';
import 'package:jp_flashcard/screens/repo_page/edit_flashcard_page.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/databases/flashcard_database.dart';
import 'package:jp_flashcard/services/text_to_speech.dart';
import 'package:jp_flashcard/components/displayed_word.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FlashcardCard extends StatelessWidget {
  //ANCHOR Variables
  int repoId;
  int index;
  FlashcardInfo flashcardInfo;

  //ANCHOR Constructor
  FlashcardCard({
    this.repoId,
    this.flashcardInfo,
    this.index,
  });

  //ANCHOR Navigate to flashcard page
  void _navigateToFlashcardPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return FlashcardPage(
        flashcardIndex: index,
        displayedFlashcardList: _flashcardManager.displayedFlashcardList,
      );
    })).then((_) {
      _flashcardManager.refresh();
      _displayingSettings.refresh();
    });
  }

  //ANCHOR Navigate to flashcard page
  void _navigateToEditFlashcardPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditFlashcardPage(
        repoId: repoId,
        flashcardInfo: flashcardInfo,
      );
    })).then((_) {
      _flashcardManager.refresh();
    });
  }

  //ANCHOR Delete flashcard dialog
  Future<dynamic> _deleteFlashcardDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['delete flashcard alert title'] ?? '',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        //ANCHOR Content
        content:
            Text(DisplayedString.zhtw['delete flashcard alert content'] ?? ''),
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),

        //ANCHOR Action buttons
        actions: <Widget>[
          //ANCHOR Cancel button
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              DisplayedString.zhtw['cancel'] ?? '',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),

          //ANCHOR Confirm button
          FlatButton(
            onPressed: () async {
              Navigator.of(context).pop();
              FlashcardDatabase.db(repoId)
                  .deleteFlashcard(flashcardInfo.flashcardId);
              await _flashcardManager.refresh();
              _repoInfo.refresh();
            },
            child: Text(
              DisplayedString.zhtw['confirm'] ?? '',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }

  //ANCHOR Reset progress dialog
  Future<dynamic> _resetProgressDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['reset progress'] ?? '',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        //ANCHOR Content
        content:
            Text(DisplayedString.zhtw['reset flashcard progress alert'] ?? ''),
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),

        //ANCHOR Action buttons
        actions: <Widget>[
          //ANCHOR Cancel button
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              DisplayedString.zhtw['cancel'] ?? '',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),

          //ANCHOR Confirm button
          FlatButton(
            onPressed: () async {
              await FlashcardDatabase.db(repoId)
                  .updateProgress(flashcardInfo.flashcardId, 0);
              Navigator.of(context).pop();

              await _flashcardManager.refresh();
              _repoInfo.refresh();
            },
            child: Text(
              DisplayedString.zhtw['confirm'] ?? '',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }

  //ANCHOR Initialize displayed definition list
  List<Widget> _displayedDefinitionList = [];
  void _initDisplayedDefinitionList() {
    _displayedDefinitionList.clear();
    int i = 1;
    for (final definition in flashcardInfo.definition) {
      _displayedDefinitionList.add(Padding(
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

  void _speak() {
    TextToSpeech.tts.speak('ja-JP', flashcardInfo.word);
    return;
  }

  //ANCHOR Initialize variables
  FlashcardManager _flashcardManager;
  WordDisplayingSettings _displayingSettings;
  RepoInfo _repoInfo;
  void initVariables(BuildContext context) {
    _flashcardManager = Provider.of<FlashcardManager>(context, listen: false);
    _displayingSettings =
        Provider.of<WordDisplayingSettings>(context, listen: false);
    _repoInfo = Provider.of<RepoInfo>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    //ANCHOR Initialize
    _initDisplayedDefinitionList();
    initVariables(context);

    //ANCHOR Flashcard card widget
    return Container(
      padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(5),
          onTap: () {
            _navigateToFlashcardPage(context);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 12, 0, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //ANCHOR Displayed word and definition list
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //ANCHOR Displayed word
                      DisplayedWord(
                        flashcardInfo: flashcardInfo,
                        displayedWordSize: DisplayedWordSize.medium(),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      //ANCHOR Displayed definition list
                      ..._displayedDefinitionList,
                    ],
                  ),
                ),

                //ANCHOR Action buttons
                Row(
                  children: <Widget>[
                    //ANCHOR Speech button
                    IconButton(
                      icon: Icon(
                        Icons.volume_up,
                        size: 23.0,
                      ),
                      onPressed: () {
                        _speak();
                      },
                    ),

                    //ANCHOR Favorite button
                    IconButton(
                      icon: Icon(
                        flashcardInfo.favorite ? Icons.star : Icons.star_border,
                        size: 23.0,
                      ),
                      onPressed: () {
                        _flashcardManager
                            .toggleFavorite(flashcardInfo.flashcardId);
                      },
                    ),

                    //ANCHOR More info button
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      offset: Offset(0, 100),
                      tooltip: DisplayedString.zhtw['more'] ?? '',
                      onSelected: (String result) async {
                        if (result == 'edit') {
                          //ANCHOR Edit button
                          _navigateToEditFlashcardPage(context);
                        } else if (result == 'reset progress') {
                          //ANCHOR Reset progress button
                          _resetProgressDialog(context);
                        } else if (result == 'delete') {
                          //ANCHOR Delete button
                          _deleteFlashcardDialog(context);
                        }
                      },

                      //ANCHOR Button list
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text(DisplayedString.zhtw['edit'] ?? ''),
                        ),
                        PopupMenuItem<String>(
                          value: 'reset progress',
                          child: Text(
                              DisplayedString.zhtw['reset progress'] ?? ''),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(DisplayedString.zhtw['delete'] ?? ''),
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
