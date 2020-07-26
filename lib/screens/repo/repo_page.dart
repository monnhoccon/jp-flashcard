import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/flashcard_list.dart';
import 'package:jp_flashcard/models/general_settings.dart';
import 'package:jp_flashcard/models/kanj_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/learning/learning_page.dart';
import 'package:jp_flashcard/screens/repo/add_flashcard.dart';
import 'package:jp_flashcard/screens/flashcard_page/displayed_flashcard.dart';
import 'package:jp_flashcard/screens/flashcard_page/flashcard_page.dart';
import 'package:jp_flashcard/screens/repo/widget/flashcard_card.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:jp_flashcard/services/refresh_page.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RepoPage extends StatefulWidget {
  RepoInfo repoInfo;
  RepoPage({this.repoInfo});
  @override
  _RepoPageState createState() => _RepoPageState();
}

class _RepoPageState extends State<RepoPage> {
  //ANCHOR Variables
  List<FlashcardCard> flashcardCardList = [];
  List<FlashcardInfo> flashcardInfoList = [];
  List<Widget> flashcardList = [];

  Future<bool> updateFlashcardCardList() async {
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
        ));

        flashcardList.add(DisplayedFlashcard(
          repoId: widget.repoInfo.repoId,
          flashcardInfo: info,
          hasFurigana: true,
        ));

        flashcardCardIndex++;
      }
    });
    /*
    DBManager.db
        .updateNumTotalOfRepo(widget.repoInfo.repoId, flashcardInfoList.length);
        */
    return true;
  }

  void navigateToFlashcard(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return FlashcardPage(
        flashcardIndex: index,
        flashcardList: flashcardList,
      );
    })).then((value) {
      updateFlashcardCardList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RefreshPage>(
      create: (context) {
        return RefreshPage();
      },
      child: Consumer<RefreshPage>(
        builder: (context, refreshPage, child) {
          return FutureBuilder(
            future: updateFlashcardCardList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider<DisplayingSettings>(
                      create: (context) {
                        return DisplayingSettings();
                      },
                    ),
                    ChangeNotifierProvider<FlashcardList>(
                      create: (context) {
                        return FlashcardList(
                          flashcardInfoList: flashcardInfoList,
                          flashcardCardList: flashcardCardList,
                        );
                      },
                    ),
                    Provider<RepoInfo>(
                      create: (context) {
                        return widget.repoInfo;
                      },
                    ),
                  ],
                  //ANCHOR Repo page widget
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(widget.repoInfo.title),
                      //ANCHOR Setting buttons
                      actions: <Widget>[
                        //ANCHOR Kanji toggle button
                        Consumer<DisplayingSettings>(
                            builder: (context, generalSettings, child) {
                          return IconButton(
                            icon: generalSettings.hasKanji
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              generalSettings.toggleKanji();
                            },
                          );
                        }),

                        //ANCHOR Furigana toggle button
                        Consumer<DisplayingSettings>(
                            builder: (context, generalSettings, child) {
                          return IconButton(
                            icon: generalSettings.hasFurigana
                                ? Icon(Icons.speaker_notes)
                                : Icon(Icons.speaker_notes_off),
                            onPressed: () {
                              generalSettings.toggleFurigana();
                            },
                          );
                        })
                      ],
                    ),
                    body: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //ANCHOR Learning page button
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child: Row(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  if (flashcardInfoList.length > 3) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return LearningPage(
                                        repoInfo: widget.repoInfo,
                                        flashcardInfoList: flashcardInfoList,
                                      );
                                    }));
                                  }
                                },
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                                    child: Text(
                                      '學習',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //ANCHOR Flashcard card list
                        Expanded(
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification:
                                (OverscrollIndicatorNotification overscroll) {
                              overscroll.disallowGlow();
                              return false;
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ...flashcardCardList,
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),

                    //ANCHOR Add flashcard button
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddFlashcard(
                            repoId: widget.repoInfo.repoId,
                          );
                        }));
                        refreshPage.refresh();
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
