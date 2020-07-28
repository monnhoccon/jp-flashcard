import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_list.dart';
import 'package:jp_flashcard/models/displaying_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/services/quiz_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LearningPage extends StatelessWidget {
  RepoInfo repoInfo;
  FlashcardList flashcardList;
  LearningPage({this.repoInfo, this.flashcardList});

  @override
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
      child: Scaffold(
        appBar: AppBar(
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
        body: Consumer<QuizManager>(
          builder: (context, quizManager, child) {
            return quizManager.currentQuiz;
          },
        ),
      ),
    );
  }
}
