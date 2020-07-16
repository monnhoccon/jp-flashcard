import 'package:jp_flashcard/models/kanj_info.dart';

class FlashcardInfo {
  String word;
  List<String> wordType;
  List<String> definition;
  List<KanjiInfo> kanji;
  FlashcardInfo({this.word, this.definition, this.kanji, this.wordType});
}
