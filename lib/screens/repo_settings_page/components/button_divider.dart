import 'package:flutter/material.dart';

class ButtonDivider extends StatelessWidget {
  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Button divider
    return Divider(
      thickness: 1,
      height: 0,
      indent: 17,
      endIndent: 17,
      color: Colors.grey[400],
    );
  }
}
