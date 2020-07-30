import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/furigana_toggle_button.dart';
import 'package:jp_flashcard/components/kanji_toggle_button.dart';
import 'package:jp_flashcard/models/word_displaying_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/quiz_settings_page/quiz_settings_page.dart';
import 'package:jp_flashcard/services/quiz_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class QuizPage extends StatelessWidget {
  RepoInfo repoInfo;
  QuizPage({this.repoInfo});

  Future<void> navigateToQuizSettingsPage(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return QuizSettingsPage();
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
        ChangeNotifierProvider<WordDisplayingSettings>(
          create: (context) {
            return WordDisplayingSettings();
          },
        ),
        ChangeNotifierProvider<QuizManager>(
          create: (context) {
            return QuizManager(
              repoId: repoInfo.repoId,
              context: context,
            );
          },
        ),
      ],

      child: Builder(
        builder: (context) {
          //ANCHOR Quiz page
          return Scaffold(
            appBar: AppBar(
              //ANCHOR Setting buttons
              actions: <Widget>[
                //ANCHOR Kanji toggle button
                KanjiToggleButton(),

                //ANCHOR Furigana toggle button
                FuriganaToggleButton(),

                //ANCHOR Quiz settings button
                IconButton(
                  icon: Icon(Icons.tune),
                  onPressed: () {
                    navigateToQuizSettingsPage(context);
                  },
                ),
              ],
            ),

            //ANCHOR Quiz
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
