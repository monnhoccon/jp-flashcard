import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screen/repo/flashcard.dart';

class FlashcardCard extends StatefulWidget {
  int repoId;
  int flashcardCardIndex;
  FlashcardInfo info;
  Function navigateToFlashcard;
  @override
  FlashcardCard({this.repoId, this.info, this.flashcardCardIndex, this.navigateToFlashcard});
  _FlashcardCardState createState() => _FlashcardCardState();
}

class _FlashcardCardState extends State<FlashcardCard> {
  //ANCHOR Variables
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(5),
          onTap: () {
            widget.navigateToFlashcard(widget.flashcardCardIndex);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: Text(
              widget.info.word,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
