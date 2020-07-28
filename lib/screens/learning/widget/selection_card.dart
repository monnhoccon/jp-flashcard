import 'package:flutter/material.dart';

class SelectionCard extends StatelessWidget {
  final displayedString;
  final Function applySelection;
  final int index;
  SelectionCard({this.displayedString, this.applySelection, this.index});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(10),
        onTap: () {
          applySelection(index, context);
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text(
            displayedString,
            style: TextStyle(
              fontSize: 22,
              height: 1
            ),
          ),
        ),
      ),
    );
  }
}
