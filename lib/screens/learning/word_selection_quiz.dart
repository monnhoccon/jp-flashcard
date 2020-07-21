import 'dart:math';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/learning/answer_correct_dialog.dart';
import 'package:jp_flashcard/screens/learning/answer_incorrect_dialog.dart';
import 'package:jp_flashcard/screens/learning/widget/selection_card.dart';
import 'package:jp_flashcard/services/database.dart';

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
  String definition;
  List<String> wordList = [];

  void getWordList() async {
    wordList.clear();
    await DBManager.db
        .getWordListExcept(widget.repoId, widget.flashcardInfo.flashcardId)
        .then((result) {
      setState(() {
        for (final word in result) {
          wordList.add(word['word']);
        }
        generateDisplayedWordList();
      });
    });
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
    setState(() {
      for (final index in randomIndexSet) {
        displayedWordList.add(wordList[index]);
      }

      displayedWordList.insert(correctAnswerIndex, widget.flashcardInfo.word);
    });
  }

  void select(int index) async {
    if (index == correctAnswerIndex) {
      AnswerCorrectDialog answerCorrectDialog = AnswerCorrectDialog(
        flashcardInfo: widget.flashcardInfo,
        hasFurigana: widget.hasFurigana,
      );
      await answerCorrectDialog.dialog(context);
    } else {
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
  void initState() {
    super.initState();
    getWordList();
    definition = randomChoice(widget.flashcardInfo.definition);
  }

  @override
  Widget build(BuildContext context) {
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
                  definition,
                  style: TextStyle(fontSize: 35, height: 1.2),
                ),
              ],
            ),
          ),
          Container(
              height: 300,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
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
                          select: select,
                          index: index,
                        ),
                      );
                    }),
              ))
        ],
      ),
    );
  }
}