import 'dart:math';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/learning/quiz_answer_dialog.dart';
import 'package:jp_flashcard/screens/learning/widget/selection_card.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:jp_flashcard/components/displayed_word.dart';
import 'package:jp_flashcard/services/quiz_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DefinitionSelectionQuiz extends StatelessWidget {
  //ANCHOR Public Variables
  final FlashcardInfo flashcardInfo;

  //ANCHOR Constructor
  DefinitionSelectionQuiz({this.flashcardInfo});

  //ANCHOR Generate displayed defintion list
  List<String> _definitionList = [];
  List<String> _displayedDefinitionList = [];
  int _correctAnswerIndex;

  Future<bool> getDefinitionList() async {
    _definitionList.clear();
    await DBManager.db
        .getDefinitionListExcept(_repoId, flashcardInfo.flashcardId)
        .then((result) {
      for (final definition in result) {
        _definitionList.add(definition['definition']);
      }
      generateDisplayedDefinitionList();
    });
    return true;
  }

  void generateDisplayedDefinitionList() {
    _displayedDefinitionList.clear();

    //Generate 3 random integers
    Set<int> randomIndexSet = Set();
    while (randomIndexSet.length < 3) {
      randomIndexSet.add(Random().nextInt(_definitionList.length));
    }

    //Add inorrect answers to the list
    for (final index in randomIndexSet) {
      _displayedDefinitionList.add(_definitionList[index]);
    }

    //Add correct answer to the list
    _correctAnswerIndex = Random().nextInt(4);
    _displayedDefinitionList.insert(
        _correctAnswerIndex, randomChoice(flashcardInfo.definition));
  }

  //ANCHOR Apply selection
  void applySelection(int index, BuildContext context) async {
    if (index == _correctAnswerIndex) {
      await QuizAnswerDialog.correct(flashcardInfo).dialog(context);
    } else {
      await QuizAnswerDialog.incorrect(flashcardInfo).dialog(context);
    }
    Provider.of<QuizManager>(context, listen: false).navigateToNextQuiz();
  }

  //ANCHOR Initialize variables
  int _repoId;
  void initVariables(BuildContext context) {
    _repoId = Provider.of<RepoInfo>(context, listen: false).repoId;
  }

  @override
  //ANCHOR Build
  Widget build(BuildContext context) {
    //ANCHOR Initialize
    initVariables(context);

    return FutureBuilder<bool>(
      future: getDefinitionList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //ANCHOR Definition selection quiz qidget
          return Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //ANCHOR Displayed word
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DisplayedWord(
                        flashcardInfo: flashcardInfo,
                        displayedWordSize: DisplayedWordSize.large(),
                      )
                    ],
                  ),
                ),

                //ANCHOR Displayed definition list
                Container(
                  height: 300,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowGlow();
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: _displayedDefinitionList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                          child: SelectionCard(
                            displayedString: _displayedDefinitionList[index],
                            applySelection: applySelection,
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
