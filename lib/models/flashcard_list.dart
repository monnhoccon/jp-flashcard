import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/flashcard_page/displayed_flashcard.dart';
import 'package:jp_flashcard/screens/repo/widget/flashcard_card.dart';

class FlashcardList with ChangeNotifier {
  int repoId;
  List<FlashcardInfo> flashcardInfoList;
  List<FlashcardCard> flashcardCardList;
  List<Widget> displayedFlashcardList;

  void initVariables() {
    for (int i = 0; i < flashcardInfoList.length; i++) {
      flashcardCardList.add(FlashcardCard(
        repoId: repoId,
        flashcardInfo: flashcardInfoList[i],
        flashcardCardIndex: i,
      ));

      displayedFlashcardList.add(DisplayedFlashcard(
        repoId: repoId,
        flashcardInfo: flashcardInfoList[i],
        hasFurigana: true,
      ));
    }
  }

  FlashcardList({
    this.repoId,
    this.flashcardInfoList,
    this.flashcardCardList,
    this.displayedFlashcardList,
  });
}
