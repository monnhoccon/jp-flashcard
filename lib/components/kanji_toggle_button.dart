import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/word_displaying_settings.dart';
import 'package:provider/provider.dart';

class KanjiToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WordDisplayingSettings>(
      builder: (context, generalSettings, child) {
        return IconButton(
          icon: generalSettings.hasKanji
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
          onPressed: () {
            generalSettings.toggleKanji();
          },
        );
      },
    );
  }
}
