import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screen/learning/definition_selection_quiz.dart';
import 'package:jp_flashcard/screen/learning/definition_short_answer_quiz.dart';
import 'package:jp_flashcard/screen/learning/word_selection_quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool hasFurigana = true;
  var persistData;
  void getPersistData() async {
    persistData = await SharedPreferences.getInstance();
    setState(() {
      hasFurigana = persistData.getBool('hasFurigana') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    getPersistData();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
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
        ],
      ),
      body: DefinitionSelectionQuiz(
        flashcardInfo: widget.flashcardInfoList[2],
        repoId: widget.repoInfo.repoId,
        hasFurigana: hasFurigana,
      ),
    );
  }
}
