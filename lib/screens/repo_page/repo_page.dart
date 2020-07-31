import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/furigana_toggle_button.dart';
import 'package:jp_flashcard/components/kanji_toggle_button.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/screens/repo_settings_page/components/flashcard_manager.dart';
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
  void _navigateToAddFlashcardPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddFlashcard(
        repoId: repoInfo.repoId,
      );
    })).then((_) async {
      await _flashcardManager.refresh();
      _repoInfo.refresh();
    });
    return;
  }

  void _navigateToQuizSettingsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return QuizSettingsPage();
    }));
    return;
  }

  void _navigateToRepoSettingsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RepoSettingsPage(
        repoInfo: repoInfo,
      );
    })).then((_) async {
      await _flashcardManager.refresh();
      _repoInfo.refresh();
    });
    return;
  }

  void _navigateToQuizPage(BuildContext context) {
    if (_flashcardManager.flashcardInfoList.length > 4) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return QuizPage(
          repoInfo: repoInfo,
        );
      })).then((_) async {
        await _flashcardManager.refresh();
        _displayingSettings.refresh();
        _repoInfo.refresh();
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(DisplayedString.zhtw['no enough cards'] ?? ''),
      ));
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
        ChangeNotifierProvider<RepoInfo>(
          create: (context) {
            return RepoInfo.from(repoInfo);
          },
        ),
      ],
      child: _repoPage(),
    );
  }

  //ANCHOR Initialize varialbes
  FlashcardManager _flashcardManager;
  WordDisplayingSettings _displayingSettings;
  RepoInfo _repoInfo;
  void initVariables(BuildContext context) {
    _flashcardManager = Provider.of<FlashcardManager>(context, listen: false);
    _displayingSettings =
        Provider.of<WordDisplayingSettings>(context, listen: false);
    _repoInfo = Provider.of<RepoInfo>(context, listen: false);
  }

  //ANCHOR Repo page
  Widget _repoPage() {
    return Builder(builder: (context) {
      //ANCHOR Initailize
      initVariables(context);

      return Scaffold(
        appBar: AppBar(
          //ANCHOR Title
          title: Consumer<RepoInfo>(builder: (context, repoInfo, child) {
            return Text(repoInfo.title);
          }),

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
                _navigateToRepoSettingsPage(context);
              },
            )
          ],
        ),
        body: Builder(builder: (context) {
          return NoOverscrollGlow(
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
                        Consumer<RepoInfo>(builder: (context, repoInfo, child) {
                          return Text(
                            '${repoInfo.numMemorized}/${repoInfo.numTotal} 已學習',
                            style: TextStyle(fontSize: 15),
                          );
                        }),
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
                                  _navigateToQuizPage(context);
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
                                _navigateToQuizSettingsPage(context);
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
          );
        }),

        //ANCHOR Add flashcard button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddFlashcardPage(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    });
  }
}
