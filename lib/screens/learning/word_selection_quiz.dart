import 'dart:math';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/learning/quiz_answer_dialog.dart';
import 'package:jp_flashcard/screens/learning/widget/selection_card.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:jp_flashcard/services/quiz_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WordSelectionQuiz extends StatefulWidget {
  int repoId;
  FlashcardInfo flashcardInfo;
  Function nextQuiz;
  bool hasFurigana;
  WordSelectionQuiz(
      {this.flashcardInfo, this.repoId, this.hasFurigana, this.nextQuiz});
  @override
  _WordSelectionQuizState createState() => _WordSelectionQuizState();
}

class _WordSelectionQuizState extends State<WordSelectionQuiz> {
  
  String displayedDefinition;
  List<String> wordList = [];

  Future<bool> getWordList() async {
    wordList.clear();
    displayedDefinition = randomChoice(widget.flashcardInfo.definition);
    await DBManager.db
        .getWordListExcept(widget.repoId, widget.flashcardInfo.flashcardId)
        .then((resultWordList) {
      for (final word in resultWordList) {
        wordList.add(word['word']);
      }
      generateDisplayedWordList();
    });
    return true;
  }

  //ANCHOR Generate displayed word list
  List<String> displayedWordList = [];
  int correctAnswerIndex;

  void generateDisplayedWordList() {
    displayedWordList.clear();
    Set<int> randomIndexSet = Set();
    var randomGenerator = Random();
    while (randomIndexSet.length < 3) {
      randomIndexSet.add(randomGenerator.nextInt(wordList.length));
    }

    correctAnswerIndex = randomGenerator.nextInt(4);

    for (final index in randomIndexSet) {
      displayedWordList.add(wordList[index]);
    }

    displayedWordList.insert(correctAnswerIndex, widget.flashcardInfo.word);
  }

  void select(int index, BuildContext context) async {
    if (index == correctAnswerIndex) {
      QuizAnswerDialog answerCorrectDialog = QuizAnswerDialog(
        flashcardInfo: widget.flashcardInfo,
        answerCorrect: true,
      );
      await answerCorrectDialog.dialog(context);
    } else {
      QuizAnswerDialog answerIncorrectDialog = QuizAnswerDialog(
        flashcardInfo: widget.flashcardInfo,
        answerCorrect: false,
      );
      await answerIncorrectDialog.dialog(context);
    }
    Provider.of<QuizManager>(context, listen: false).navigateToNextQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getWordList(),
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
                        Text(
                          displayedDefinition,
                          style: TextStyle(fontSize: 35, height: 1.2),
                        ),
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
                            itemCount: displayedWordList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                                child: SelectionCard(
                                  displayedString: displayedWordList[index],
                                  applySelection: select,
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
