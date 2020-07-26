import 'dart:math';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_settings.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/learning/answer_correct_dialog.dart';
import 'package:jp_flashcard/screens/learning/answer_incorrect_dialog.dart';
import 'package:jp_flashcard/screens/learning/widget/selection_card.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:jp_flashcard/components/displayed_word.dart';

// ignore: must_be_immutable
class DefinitionSelectionQuiz extends StatelessWidget {
  int repoId;
  FlashcardInfo flashcardInfo;
  bool hasFurigana;
  Function nextQuiz;
  DefinitionSelectionQuiz(
      {this.flashcardInfo, this.repoId, this.hasFurigana, this.nextQuiz});
 
  List<String> definition = [];
  List<String> definitionList = [];

  Future<bool> getDefinitionList() async {
    definition = flashcardInfo.definition;
    definitionList.clear();
    await DBManager.db
        .getDefinitionListExcept(
            repoId, flashcardInfo.flashcardId)
        .then((result) {
      for (final definition in result) {
        definitionList.add(definition['definition']);
      }
      generateDisplayedDefinitionList();
    });
    return true;
  }

  //ANCHOR Generate displayed defintion list
  List<String> displayedDefinitionList = [];
  int correctAnswerIndex;

  void generateDisplayedDefinitionList() {
    displayedDefinitionList.clear();
    Set<int> randomIndexSet = Set();
    var randomGenerator = Random();
    while (randomIndexSet.length < 3) {
      randomIndexSet.add(randomGenerator.nextInt(definitionList.length));
    }

    correctAnswerIndex = randomGenerator.nextInt(4);

    for (final index in randomIndexSet) {
      displayedDefinitionList.add(definitionList[index]);
    }

    displayedDefinitionList.insert(
        correctAnswerIndex, randomChoice(definition));
  }

  void select(int index, BuildContext context) async {
    if (index == correctAnswerIndex) {
      AnswerCorrectDialog answerCorrectDialog = AnswerCorrectDialog(
        flashcardInfo: flashcardInfo,
        hasFurigana: hasFurigana,
      );
      await answerCorrectDialog.dialog(context);
    } else {
      //TODO Get incorrect flashcardinfo
      AnswerIncorrectDialog answerIncorrectDialog = AnswerIncorrectDialog(
        incorrectFlashcardInfo: flashcardInfo,
        correctFlashcardInfo: flashcardInfo,
        hasFurigana: hasFurigana,
      );
      await answerIncorrectDialog.dialog(context);
    }
    nextQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getDefinitionList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DisplayedWord(
                          flashcardInfo: flashcardInfo,
                          displayedWordSettings: DisplayedWordSettings.large(),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: 300,
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overscroll) {
                          overscroll.disallowGlow();
                          return false;
                        },
                        child: ListView.builder(
                            itemCount: displayedDefinitionList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                                child: SelectionCard(
                                  displayedString:
                                      displayedDefinitionList[index],
                                  select: select,
                                  index: index,
                                ),
                              );
                            }),
                      ))
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
