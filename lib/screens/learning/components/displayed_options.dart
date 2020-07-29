import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/screens/learning/components/selection_card.dart';

class DisplayedOptions extends StatelessWidget {
  final List<dynamic> options;
  final Function applySelection;
  final bool onlyString;
  DisplayedOptions({this.options, this.onlyString, this.applySelection});

  @override
  Widget build(BuildContext context) {
    return NoOverscrollGlow(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                child: SelectionCard(
                  content: options[index],
                  onlyString: onlyString,
                  applySelection: applySelection,
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
