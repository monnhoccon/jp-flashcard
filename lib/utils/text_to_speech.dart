import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  String language;
  FlutterTts flutterTts;
  TextToSpeech({this.language}) {
    flutterTts = FlutterTts();
    flutterTts.setLanguage(language);
  }
  static final jpTts = TextToSpeech(language: 'ja-JP');
  static final enTts = TextToSpeech(language: 'en-US');

  void speak(String text) {
    flutterTts.speak(text);
  }
}
