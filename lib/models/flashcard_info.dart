import 'package:jp_flashcard/models/kanj_info.dart';

class FlashcardInfo {
  int flashcardId;
  String word;
  List<String> definition;
  List<KanjiInfo> kanji;
  List<String> wordType;
  FlashcardInfo({
    this.flashcardId,
    this.word,
    this.definition,
    this.kanji,
    this.wordType,
  });
}
