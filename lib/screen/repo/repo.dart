import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/kanj_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screen/repo/add_flashcard.dart';
import 'package:jp_flashcard/screen/repo/flashcard_card.dart';
import 'package:jp_flashcard/screen/repo/test.dart';
import 'package:jp_flashcard/utils/database.dart';

class Repo extends StatefulWidget {
  RepoInfo repoInfo;
  Repo({this.repoInfo});
  @override
  _RepoState createState() => _RepoState();
}

class _RepoState extends State<Repo> {
  //ANCHOR Variables
  List<Widget> flashcardCardList = [];

  Future<void> updateFlashcardCardList() async {
    flashcardCardList.clear();

    await DBManager.db.getFlashcard(widget.repoInfo.repoId).then((data) {
      var flashcardList = data['word'];
      var definitionTable = data['definition'];
      var kanjiTable = data['kanji'];
      var wordTypeTable = data['wordType'];
      for (final flashcard in flashcardList) {
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
          flashcardCardList.add(FlashcardCard(
              info: FlashcardInfo(
                  flashcardId: flashcardId,
                  word: word,
                  definition: definitionList,
                  kanji: kanjiList,
                  wordType: wordTypeList)));
        });
      }
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    updateFlashcardCardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.repoInfo.title),
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