import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screen/learning/definition_selection_quiz.dart';
import 'package:jp_flashcard/screen/learning/definition_short_answer_quiz.dart';

class LearningPage extends StatefulWidget {
  RepoInfo repoInfo;
  List<FlashcardInfo> flashcardInfoList;
  LearningPage({this.repoInfo, this.flashcardInfoList});
  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  int flashcardLength;
  var randomGenerator;
  @override
  void initState() {
    super.initState();
    flashcardLength = widget.flashcardInfoList.length;
    randomGenerator = Random();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefinitionShortAnswerQuiz(
        flashcardInfo: widget.flashcardInfoList[2],
        repoId: widget.repoInfo.repoId,
      ),
    );
  }
}
