import 'package:flutter/material.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class StatisticsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          DisplayedString.zhtw['developing'] ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
