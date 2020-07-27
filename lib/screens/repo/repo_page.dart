import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_list.dart';
import 'package:jp_flashcard/models/general_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/learning/learning_page.dart';
import 'package:jp_flashcard/screens/repo/add_flashcard.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RepoPage extends StatelessWidget {
  //ANCHOR Variables
  RepoInfo repoInfo;

  //ANCHOR Constructor
  RepoPage({this.repoInfo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBManager.db.getFlashcardInfoList(repoInfo.repoId),
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
                    repoId: repoInfo.repoId,
                    flashcardInfoList: snapshot.data,
                  );
                },
              ),
              Provider<RepoInfo>(
                create: (context) {
                  return repoInfo;
                },
              ),
            ],
            child: repoPage(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  //ANCHOR Initialize varialbes
  FlashcardList _flashcardList;
  void initVariables(BuildContext context) {
    _flashcardList = Provider.of<FlashcardList>(context, listen: false);
  }

  //ANCHOR Repo Page widget
  Widget repoPage() {
    return Builder(builder: (context) {
      initVariables(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(repoInfo.title),
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
                      if (_flashcardList.flashcardInfoList.length > 3) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LearningPage(
                            repoInfo: repoInfo,
                            flashcardInfoList: _flashcardList.flashcardInfoList,
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
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return false;
                },
                child: SingleChildScrollView(
                  child: Consumer<FlashcardList>(
                      builder: (context, flashcardList, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...flashcardList.flashcardCardList,
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        )),

        //ANCHOR Add flashcard button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddFlashcard(
                repoId: repoInfo.repoId,
              );
            })).then((newFlashcardInfo) {
              _flashcardList.refresh();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    });
  }
}
