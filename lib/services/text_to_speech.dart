import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  FlutterTts flutterTts = FlutterTts();
  bool lastComplete = true;

  static final tts = TextToSpeech();

  Future<void> waitSpeakingComplete() async {
    int i = 0;
    while (!lastComplete && i < 15) {
      await new Future.delayed(const Duration(milliseconds: 500));
      i++;
    }
  }

  Future<void> speak(String language, String text) async {
    flutterTts.setLanguage(language);
    flutterTts.setCompletionHandler(() {
      lastComplete = true;
    });
    lastComplete = false;
    flutterTts.speak(text);
    await waitSpeakingComplete();
    return;
  }
}
