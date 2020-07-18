import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/kanj_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screen/learning/learning_page.dart';
import 'package:jp_flashcard/screen/repo/add_flashcard.dart';
import 'package:jp_flashcard/screen/repo/flashcard.dart';
import 'package:jp_flashcard/screen/repo/widget/flashcard_card.dart';
import 'package:jp_flashcard/utils/database.dart';

// ignore: must_be_immutable
class FlashcardPage extends StatefulWidget {
  int flashcardIndex;
  List<Widget> flashcardList = [];
  FlashcardPage({this.flashcardIndex, this.flashcardList});
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  //ANCHOR Variables

  bool playFlashcards = false;
  bool inFlashcardPage = false;
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Future<void> changePage() async {
    for (int i = _currentPage; i < widget.flashcardList.length; i++) {
      Flashcard flashcard = widget.flashcardList[i];

      if (!inFlashcardPage || !playFlashcards) break;
      flashcard.flipPageToFront();

      if (!inFlashcardPage || !playFlashcards) break;
      await flashcard.speakWord();

      if (!inFlashcardPage || !playFlashcards) break;
      flashcard.flipPageToBack();

      await Future.delayed(Duration(milliseconds: 500));
      if (!inFlashcardPage || !playFlashcards) break;
      await flashcard.speakDefinition();

      if (_currentPage < widget.flashcardList.length) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (!inFlashcardPage || !playFlashcards) break;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    super.initState();
    inFlashcardPage = true;
    playFlashcards = false;
    _pageController = PageController(initialPage: widget.flashcardIndex);
    _currentPage = widget.flashcardIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            inFlashcardPage = false;
            Navigator.maybePop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: !playFlashcards ? Icon(Icons.play_arrow) : Icon(Icons.pause),
            onPressed: () {
              setState(() {
                if (!playFlashcards) {
                  playFlashcards = true;
                  changePage();
                } else {
                  playFlashcards = false;
                }
              });
            },
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: widget.flashcardList,
        onPageChanged: (index) {
          _currentPage = index;
        },
      ),
    );
  }
}
