import 'dart:math';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/learning/answer_correct_dialog.dart';
import 'package:jp_flashcard/screens/learning/answer_incorrect_dialog.dart';
import 'package:jp_flashcard/screens/learning/widget/selection_card.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:jp_flashcard/components/displayed_word.dart';

// ignore: must_be_immutable
class DefinitionSelectionQuiz extends StatefulWidget {
  int repoId;
  FlashcardInfo flashcardInfo;
  bool hasFurigana;
  Function nextQuiz;
  DefinitionSelectionQuiz(
      {this.flashcardInfo, this.repoId, this.hasFurigana, this.nextQuiz});
  @override
  _DefinitionSelectionQuizState createState() =>
      _DefinitionSelectionQuizState();
}

class _DefinitionSelectionQuizState extends State<DefinitionSelectionQuiz> {
  List<String> definition = [];
  List<String> definitionList = [];

  Future<List<String>> getDefinitionList() async {
    definition = widget.flashcardInfo.definition;
    definitionList.clear();
    await DBManager.db
        .getDefinitionListExcept(
            widget.repoId, widget.flashcardInfo.flashcardId)
        .then((result) {
      for (final definition in result) {
        definitionList.add(definition['definition']);
      }
      generateDisplayedDefinitionList();
    });
    return displayedDefinitionList;
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

  void select(int index) async {
    if (index == correctAnswerIndex) {
      AnswerCorrectDialog answerCorrectDialog = AnswerCorrectDialog(
        flashcardInfo: widget.flashcardInfo,
        hasFurigana: widget.hasFurigana,
      );
      await answerCorrectDialog.dialog(context);
    } else {
      //TODO Get incorrect flashcardinfo
      AnswerIncorrectDialog answerIncorrectDialog = AnswerIncorrectDialog(
        incorrectFlashcardInfo: widget.flashcardInfo,
        correctFlashcardInfo: widget.flashcardInfo,
        hasFurigana: widget.hasFurigana,
      );
      await answerIncorrectDialog.dialog(context);
    }
    widget.nextQuiz();
  }

  @override
  Widget build(BuildContext context) {
    print('jey');
    return FutureBuilder<List<String>>(
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
                          flashcardInfo: widget.flashcardInfo,
                          hasFurigana: widget.hasFurigana,
                          textFontSize: 35,
                          furiganaFontSize: 15,
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
