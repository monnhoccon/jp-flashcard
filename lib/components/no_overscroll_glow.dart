import 'package:flutter/material.dart';

class NoOverscrollGlow extends StatelessWidget {
  //ANCHOR Public Variables
  final Widget child;

  //ANCHOR Constructor
  NoOverscrollGlow({this.child});

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR No overscroll glow
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
        return false;
      },
      child: child,
    );
  }
}
