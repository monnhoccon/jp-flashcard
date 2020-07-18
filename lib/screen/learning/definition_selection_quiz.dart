import 'dart:math';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screen/learning/widget/selection_card.dart';
import 'package:jp_flashcard/utils/database.dart';
import 'package:jp_flashcard/widget/displayed_word.dart';

// ignore: must_be_immutable
class DefinitionSelectionQuiz extends StatefulWidget {
  int repoId;
  FlashcardInfo flashcardInfo;
  DefinitionSelectionQuiz({this.flashcardInfo, this.repoId});
  @override
  _DefinitionSelectionQuizState createState() =>
      _DefinitionSelectionQuizState();
}

class _DefinitionSelectionQuizState extends State<DefinitionSelectionQuiz> {
  List<String> definition = [];
  List<String> definitionList = [];

  void getDefinitionList() async {
    definitionList.clear();
    await DBManager.db
        .getDefinitionListExcept(
            widget.repoId, widget.flashcardInfo.flashcardId)
        .then((result) {
      setState(() {
        for (final definition in result) {
          definitionList.add(definition['definition']);
        }
        generateDisplayedDefinitionList();
      });
    });
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
    setState(() {
      for (final index in randomIndexSet) {
        displayedDefinitionList.add(definitionList[index]);
      }

      displayedDefinitionList.insert(
          correctAnswerIndex, randomChoice(definition));
    });
  }

  void select(int index) {
    if (index == correctAnswerIndex) {
      print('correct');
    } else {
      print('incorrect');
    }
  }

  @override
  void initState() {
    super.initState();
    getDefinitionList();
    definition = widget.flashcardInfo.definition;
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
                DisplayedWord(
                  flashcardInfo: widget.flashcardInfo,
                )
              ],
            ),
          ),
          Container(
            height: 300,
            child: ListView.builder(
                itemCount: displayedDefinitionList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                    child: SelectionCard(
                      displayedString: displayedDefinitionList[index],
                      select: select,
                      index: index,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
