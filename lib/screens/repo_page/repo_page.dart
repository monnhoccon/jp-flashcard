import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/furigana_toggle_button.dart';
import 'package:jp_flashcard/components/kanji_toggle_button.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/services/managers/flashcard_manager.dart';
import 'package:jp_flashcard/models/word_displaying_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/quiz_page/quiz_page.dart';
import 'package:jp_flashcard/screens/quiz_settings_page/quiz_settings_page.dart';
import 'package:jp_flashcard/screens/repo_page/add_flashcard_page.dart';
import 'package:jp_flashcard/screens/repo_settings_page/repo_settings_page.dart';
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
      return QuizSettingsPage();
    }));
    return;
  }

  void navigateToRepoSettingsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RepoSettingsPage(
        repoInfo: repoInfo,
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
        ChangeNotifierProvider<WordDisplayingSettings>(
          create: (context) {
            return WordDisplayingSettings();
          },
        ),
        ChangeNotifierProvider<FlashcardManager>(
          create: (context) {
            return FlashcardManager(
              repoId: repoInfo.repoId,
            );
          },
        ),
      ],
      child: repoPage(),
    );
  }

  //ANCHOR Initialize varialbes
  FlashcardManager _flashcardList;
  WordDisplayingSettings _displayingSettings;

  void initVariables(BuildContext context) {
    _flashcardList = Provider.of<FlashcardManager>(context, listen: false);
    _displayingSettings =
        Provider.of<WordDisplayingSettings>(context, listen: false);
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
            //ANCHOR Kanji toggle button
            KanjiToggleButton(),

            //ANCHOR Furigana toggle button
            FuriganaToggleButton(),

            //ANCHOR Repo settings button
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                navigateToRepoSettingsPage(context);
              },
            )
          ],
        ),
        body: NoOverscrollGlow(
          child: SingleChildScrollView(
            child: Column(
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
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                Consumer<FlashcardManager>(
                    builder: (context, flashcardList, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: flashcardList.flashcardCardList,
                  );
                }),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
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
