import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/displayed_word.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';

class SelectionCard extends StatelessWidget {
  final Function applySelection;
  final dynamic content;
  final int index;
  final bool onlyString;

  SelectionCard({
    this.content,
    this.applySelection,
    this.index,
    this.onlyString,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(10),
        onTap: () {
          applySelection(index, context);
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: onlyString
              ? Text(
                  content,
                  style: TextStyle(fontSize: 21, height: 1),
                )
              : DisplayedWord(
                  flashcardInfo: content,
                  displayedWordSize: DisplayedWordSize.medium(),
                ),
        ),
      ),
    );
  }
}
