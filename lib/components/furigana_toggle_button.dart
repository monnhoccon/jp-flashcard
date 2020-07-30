import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/word_displaying_settings.dart';
import 'package:provider/provider.dart';

class FuriganaToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WordDisplayingSettings>(
      builder: (context, generalSettings, child) {
        return IconButton(
          icon: generalSettings.hasFurigana
              ? Icon(Icons.speaker_notes)
              : Icon(Icons.speaker_notes_off),
          onPressed: () {
            generalSettings.toggleFurigana();
          },
        );
      },
    );
  }
}
