import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(DisplayedString.zhtw['profile'] ?? ''),
    );
  }
}
