import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/kanj_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/learning/learning_page.dart';
import 'package:jp_flashcard/screens/repo/add_flashcard.dart';
import 'package:jp_flashcard/screens/repo/flashcard.dart';
import 'package:jp_flashcard/screens/repo/flashcard_page.dart';
import 'package:jp_flashcard/screens/repo/widget/flashcard_card.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repo extends StatefulWidget {
  RepoInfo repoInfo;
  Repo({this.repoInfo});
  @override
  _RepoState createState() => _RepoState();
}

class _RepoState extends State<Repo> {
  //ANCHOR Variables
  List<FlashcardCard> flashcardCardList = [];
  List<FlashcardInfo> flashcardInfoList = [];
  List<Widget> flashcardList = [];

  Future<void> updateFlashcardCardList() async {
    flashcardCardList.clear();
    flashcardList.clear();
    flashcardInfoList.clear();

    int flashcardCardIndex = 0;
    await DBManager.db.getFlashcardList(widget.repoInfo.repoId).then((data) {
      var flashcardTable = data['word'];
      var definitionTable = data['definition'];
      var kanjiTable = data['kanji'];
      var wordTypeTable = data['wordType'];
      for (final flashcard in flashcardTable) {
        int flashcardId = flashcard['flashcardId'];
        String word = flashcard['word'];
        List<String> definitionList = [];
        for (final definition in definitionTable) {
          if (definition['flashcardId'] == flashcardId) {
            definitionList.add(definition['definition']);
          }
        }
        List<KanjiInfo> kanjiList = [];
        for (final kanji in kanjiTable) {
          if (kanji['flashcardId'] == flashcardId) {
            kanjiList.add(KanjiInfo(
                furigana: kanji['furigana'],
                index: kanji['ind'],
                length: kanji['length']));
          }
        }
        List<String> wordTypeList = [];
        for (final wordType in wordTypeTable) {
          if (wordType['flashcardId'] == flashcardId) {
            wordTypeList.add(wordType['wordType']);
          }
        }
        setState(() {
          FlashcardInfo info = FlashcardInfo(
            flashcardId: flashcardId,
            word: word,
            definition: definitionList,
            kanji: kanjiList,
            wordType: wordTypeList,
          );

          flashcardInfoList.add(info);

          flashcardCardList.add(FlashcardCard(
            repoId: widget.repoInfo.repoId,
            flashcardInfo: info,
            navigateToFlashcard: navigateToFlashcard,
            flashcardCardIndex: flashcardCardIndex,
            rebuildFlashcardMenu: rebuildFlashcardMenu,
            hasFurigana: hasFurigana,
          ));

          flashcardList.add(Flashcard(
            repoId: widget.repoInfo.repoId,
            flashcardInfo: info,
            hasFurigana: hasFurigana,
          ));

          flashcardCardIndex++;
        });
      }
    });
    return;
  }

  void navigateToFlashcard(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return FlashcardPage(
        flashcardIndex: index,
        flashcardList: flashcardList,
        toggleFurigana: toggleFurigana,
      );
    })).then((value) {
      updateFlashcardCardList();
    });
  }

  void rebuildFlashcardMenu() {
    updateFlashcardCardList();
  }

  bool hasFurigana = false;
  var persistData;
  void getPersistData() async {
    persistData = await SharedPreferences.getInstance();
    setState(() {
      hasFurigana = persistData.getBool('hasFurigana') ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    updateFlashcardCardList();
    getPersistData();
  }

  void toggleFurigana() {
    setState(() {
      if (!hasFurigana) {
        hasFurigana = true;
      } else {
        hasFurigana = false;
      }
    });
    updateFlashcardCardList();

    persistData.setBool('hasFurigana', hasFurigana);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.repoInfo.title),
        actions: <Widget>[
          IconButton(
            icon: hasFurigana ? Icon(Icons.label) : Icon(Icons.label_outline),
            onPressed: () {
              toggleFurigana();
            },
          )
        ],
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //ANCHOR Repo info
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  await DBManager.db
                      .deleteTable('flashcardList${widget.repoInfo.repoId}');
                  await DBManager.db
                      .deleteTable('definitionList${widget.repoInfo.repoId}');
                  await DBManager.db
                      .deleteTable('kanjiList${widget.repoInfo.repoId}');
                  await DBManager.db
                      .deleteTable('wordTypeList${widget.repoInfo.repoId}');
                  updateFlashcardCardList();
                },
                child: Text('Delete All'),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LearningPage(
                      repoInfo: widget.repoInfo,
                      flashcardInfoList: flashcardInfoList,
                    );
                  }));
                },
                child: Text('Learn'),
              ),
            ],
          ),

          //ANCHOR Flashcard card list
          Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return false;
                  },
                  child: ListView.builder(
                      itemCount: flashcardCardList.length,
                      itemBuilder: (context, index) {
                        return flashcardCardList[index];
                      }))),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddFlashcard(
              repoId: widget.repoInfo.repoId,
            );
          }));
          updateFlashcardCardList();
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
