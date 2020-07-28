import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/flashcard_page/displayed_flashcard.dart';
import 'package:jp_flashcard/screens/repo/widget/flashcard_card.dart';
import 'package:jp_flashcard/services/flashcard_manager.dart';

class FlashcardList with ChangeNotifier {
  int repoId;
  int index;
  List<FlashcardInfo> flashcardInfoList = [];
  List<FlashcardCard> flashcardCardList = [];
  List<DisplayedFlashcard> displayedFlashcardList = [];

  void toggleFavorite(int flashcardId) async {
    for (final flashcardInfo in flashcardInfoList) {
      if (flashcardInfo.flashcardId == flashcardId) {
        flashcardInfo.favorite = !flashcardInfo.favorite;
        await FlashcardManager.db(repoId)
            .updateFavorite(flashcardId, flashcardInfo.favorite);
      }
    }
    refresh();
  }

  Future<void> refresh() async {
    await FlashcardManager.db(repoId)
        .getFlashcardInfoList()
        .then((newFlashcardInfoList) {
      flashcardInfoList = newFlashcardInfoList;
    });
    flashcardCardList.clear();
    displayedFlashcardList.clear();
    for (index = 0; index < flashcardInfoList.length; index++) {
      flashcardCardList.add(FlashcardCard(
        repoId: repoId,
        flashcardInfo: flashcardInfoList[index],
        index: index,
      ));

      displayedFlashcardList.add(DisplayedFlashcard(
        repoId: repoId,
        flashcardInfo: flashcardInfoList[index],
        hasFurigana: true,
      ));
    }
    notifyListeners();
  }

  FlashcardList({this.repoId}) {
    refresh();
  }
}
