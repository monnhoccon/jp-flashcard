import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_list.dart';
import 'package:jp_flashcard/models/displaying_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/quiz_settings_page/quiz_settings_page.dart';
import 'package:jp_flashcard/services/quiz_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class QuizPage extends StatelessWidget {
  RepoInfo repoInfo;
  FlashcardList flashcardList;
  QuizPage({this.repoInfo, this.flashcardList});

  Future<void> navigateToQuizSettingsPage(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return QuizSettingsPage(
        repoId: repoInfo.repoId,
      );
    })).then((value) {
      Provider.of<QuizManager>(context, listen: false).refreshQuizSettings();
    });
  }

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    return MultiProvider(
      //ANCHOR Providers
      providers: [
        ChangeNotifierProvider<DisplayingSettings>(
          create: (context) {
            return DisplayingSettings();
          },
        ),
        ChangeNotifierProvider<QuizManager>(
          create: (context) {
            return QuizManager(repoId: repoInfo.repoId);
          },
        ),
        ChangeNotifierProvider<RepoInfo>(
          create: (context) {
            return RepoInfo.fromRepoInfo(repoInfo);
          },
        ),
      ],

      //ANCHOR Quiz page widget
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              //ANCHOR Setting buttons
              actions: <Widget>[
                //ANCHOR Quiz settings button
                IconButton(
                  icon: Icon(Icons.tune),
                  onPressed: () async {
                    await navigateToQuizSettingsPage(context);
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
            body: Consumer<QuizManager>(
              builder: (context, quizManager, child) {
                return quizManager.currentQuiz;
              },
            ),
          );
        },
      ),
    );
  }
}
