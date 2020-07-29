import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/models/flashcard_list.dart';
import 'package:jp_flashcard/models/displaying_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/learning/quiz_page.dart';
import 'package:jp_flashcard/screens/quiz_settings_page/quiz_settings_page.dart';
import 'package:jp_flashcard/screens/repo/add_flashcard_page.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RepoPage extends StatelessWidget {
  //ANCHOR Variables
  final RepoInfo repoInfo;

  //ANCHOR Constructor
  RepoPage({this.repoInfo});

  //ANCHOR Navigation
  void navigateToAddFlashcardPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddFlashcard(
        repoId: repoInfo.repoId,
      );
    })).then((newFlashcardInfo) {
      _flashcardList.refresh();
    });
    return;
  }

  void navigateToQuizSettingsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return QuizSettingsPage(
        repoId: repoInfo.repoId,
      );
    }));
    return;
  }

  void navigateToQuizPage(BuildContext context) {
    if (_flashcardList.flashcardInfoList.length > 3) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return QuizPage(
          repoInfo: repoInfo,
        );
      })).then((value) {
        _flashcardList.refresh();
        _displayingSettings.refresh();
      });
    }

    return;
  }

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Providers
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
            );
          },
        ),
        ChangeNotifierProvider<RepoInfo>(
          create: (context) {
            return repoInfo;
          },
        ),
      ],
      child: repoPage(),
    );
  }

  //ANCHOR Initialize varialbes
  FlashcardList _flashcardList;
  DisplayingSettings _displayingSettings;

  void initVariables(BuildContext context) {
    _flashcardList = Provider.of<FlashcardList>(context, listen: false);
    _displayingSettings =
        Provider.of<DisplayingSettings>(context, listen: false);
  }

  //ANCHOR Repo page
  Widget repoPage() {
    return Builder(builder: (context) {
      //ANCHOR Initailize
      initVariables(context);

      return Scaffold(
        appBar: AppBar(
          title: Text(repoInfo.title),
          //ANCHOR Setting buttons
          actions: <Widget>[
            //ANCHOR Delete all button
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                DBManager.db.deleteAllFlashcard(repoInfo.repoId);
              },
            ),

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
              Expanded(
                child: NoOverscrollGlow(
                  child: SingleChildScrollView(
                    child: Consumer<FlashcardList>(
                        builder: (context, flashcardList, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          //ANCHOR Repo info and buttons
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 15, 5, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${repoInfo.numMemorized}/${repoInfo.numTotal} 已學習',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    //ANCHOR Learning page button
                                    ButtonTheme(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 5),
                                      minWidth: 0,
                                      height: 0,
                                      child: FlatButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          navigateToQuizPage(context);
                                        },
                                        child: Text(
                                          DisplayedString.zhtw['learn'] ?? '',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    //ANCHOR Quiz settings button
                                    IconButton(
                                      icon: Icon(Icons.tune),
                                      onPressed: () {
                                        navigateToQuizSettingsPage(context);
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          //ANCHOR Flashcard card list
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
          ),
        ),

        //ANCHOR Add flashcard button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToAddFlashcardPage(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    });
  }
}
