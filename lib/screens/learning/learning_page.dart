import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/learning/definition_selection_quiz.dart';
import 'package:jp_flashcard/screens/learning/definition_short_answer_quiz.dart';
import 'package:jp_flashcard/screens/learning/kanji_short_answer_quiz.dart';
import 'package:jp_flashcard/screens/learning/word_selection_quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'word_short_answer_quiz.dart';

// ignore: must_be_immutable
class LearningPage extends StatefulWidget {
  RepoInfo repoInfo;
  List<FlashcardInfo> flashcardInfoList;
  LearningPage({this.repoInfo, this.flashcardInfoList});
  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  var randomGenerator;
  int repoId;
  List<FlashcardInfo> flashcardInfoList;
  bool hasFurigana = true;
  var persistData;
  void getPersistData() async {
    persistData = await SharedPreferences.getInstance();
    setState(() {
      hasFurigana = persistData.getBool('hasFurigana') ?? true;
    });
  }

  Widget currentQuiz;
  int lastIndex = -1;
  void nextQuiz() {
    setState(() {
      int quizType = randomGenerator.nextInt(5);
      int index = randomGenerator.nextInt(flashcardInfoList.length);
      while (index == lastIndex) {
        index = randomGenerator.nextInt(flashcardInfoList.length);
      }

      lastIndex = index;

      if (quizType == 0) {
        currentQuiz = DefinitionSelectionQuiz(
          repoId: repoId,
          flashcardInfo: flashcardInfoList[index],
          hasFurigana: hasFurigana,
          nextQuiz: nextQuiz,
        );
      } else if (quizType == 1) {
        currentQuiz = DefinitionShortAnswerQuiz(
          repoId: repoId,
          flashcardInfo: flashcardInfoList[index],
          hasFurigana: hasFurigana,
          nextQuiz: nextQuiz,
        );
      } else if (quizType == 2) {
        currentQuiz = WordSelectionQuiz(
          repoId: repoId,
          flashcardInfo: flashcardInfoList[index],
          hasFurigana: hasFurigana,
          nextQuiz: nextQuiz,
        );
      } else if (quizType == 3) {
        currentQuiz = WordShortAnswerQuiz(
          repoId: repoId,
          flashcardInfo: flashcardInfoList[index],
          hasFurigana: hasFurigana,
          nextQuiz: nextQuiz,
        );
      } else if (quizType == 4) {
        currentQuiz = KanjiShortAnswerQuiz(
          repoId: repoId,
          flashcardInfo: flashcardInfoList[index],
          hasFurigana: hasFurigana,
          nextQuiz: nextQuiz,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    repoId = widget.repoInfo.repoId;
    flashcardInfoList = widget.flashcardInfoList;
    randomGenerator = Random();
    currentQuiz = KanjiShortAnswerQuiz(
          repoId: repoId,
          flashcardInfo: flashcardInfoList[0],
          hasFurigana: hasFurigana,
          nextQuiz: nextQuiz,
        );
    //nextQuiz();
  }

  @override
  Widget build(BuildContext context) {
    getPersistData();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          /*
          IconButton(
            icon: hasFurigana ? Icon(Icons.label) : Icon(Icons.label_outline),
            onPressed: () {
              setState(() {
                if (!hasFurigana) {
                  hasFurigana = true;
                } else {
                  hasFurigana = false;
                }
                persistData.setBool('hasFurigana', hasFurigana);
              });
            },
          )
          */
        ],
      ),
      body: currentQuiz,
    );
  }
}
