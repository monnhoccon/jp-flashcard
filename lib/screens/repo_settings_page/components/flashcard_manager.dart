import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/flashcard_page/displayed_flashcard.dart';
import 'package:jp_flashcard/screens/repo_page/widget/flashcard_card.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:jp_flashcard/services/databases/flashcard_database.dart';

class FlashcardManager with ChangeNotifier {
  int repoId;
  List<FlashcardInfo> flashcardInfoList = [];
  List<FlashcardCard> flashcardCardList = [];
  List<DisplayedFlashcard> displayedFlashcardList = [];

  void toggleFavorite(int flashcardId) async {
    for (final flashcardInfo in flashcardInfoList) {
      if (flashcardInfo.flashcardId == flashcardId) {
        flashcardInfo.favorite = !flashcardInfo.favorite;
        await FlashcardDatabase.db(repoId)
            .updateFavorite(flashcardId, flashcardInfo.favorite);
      }
    }
    refresh();
    return;
  }

  Future<void> refresh() async {
    await FlashcardDatabase.db(repoId)
        .getFlashcardInfoList()
        .then((newFlashcardInfoList) {
      flashcardInfoList = newFlashcardInfoList;
    });
    flashcardCardList.clear();
    displayedFlashcardList.clear();

    int numTotal = flashcardInfoList.length;
    int numCompleted = 0;
    for (int index = 0; index < flashcardInfoList.length; index++) {
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
      
      if (flashcardInfoList[index].progress >= 100) {
        numCompleted++;
      }
      
    }

    await RepoDatabase.db.updateNumTotalOfRepo(repoId, numTotal, numCompleted);
    notifyListeners();
    return;
  }

  FlashcardManager({this.repoId}) {
    refresh();
    return;
  }
}
