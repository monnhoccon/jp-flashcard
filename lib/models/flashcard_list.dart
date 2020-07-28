import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/flashcard_page/displayed_flashcard.dart';
import 'package:jp_flashcard/screens/repo/widget/flashcard_card.dart';
import 'package:jp_flashcard/services/database.dart';

class FlashcardList with ChangeNotifier {
  int repoId;
  int index;
  List<FlashcardInfo> flashcardInfoList = [];
  List<FlashcardCard> flashcardCardList = [];
  List<DisplayedFlashcard> displayedFlashcardList = [];

  void delete(int index) {
    for (final flashcardCard in flashcardCardList) {
      if (flashcardCard.index == index) {
        for (final flashcardInfo in flashcardInfoList) {
          if (flashcardInfo == flashcardCard.flashcardInfo) {
            flashcardInfoList.remove(flashcardInfo);
            for (final displayedFlashcard in displayedFlashcardList) {
              if (displayedFlashcard.flashcardInfo == flashcardInfo) {
                displayedFlashcardList.remove(displayedFlashcard);
                break;
              }
            }
            break;
          }
        }
        flashcardCardList.remove(flashcardCard);
        notifyListeners();
        return;
      }
    }

    return;
  }

  void add(FlashcardInfo flashcardInfo) {
    flashcardInfoList.add(flashcardInfo);
    flashcardCardList.add(FlashcardCard(
      repoId: repoId,
      flashcardInfo: flashcardInfo,
      index: index,
    ));
    displayedFlashcardList.add(DisplayedFlashcard(
      repoId: repoId,
      flashcardInfo: flashcardInfo,
      hasFurigana: true,
    ));
    index++;
    notifyListeners();
    return;
  }

  Future<void> refresh() async {
    await DBManager.db
        .getFlashcardInfoList(repoId)
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
