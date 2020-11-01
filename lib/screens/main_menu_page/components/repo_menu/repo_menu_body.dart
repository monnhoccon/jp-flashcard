import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/services/managers/repo_manager.dart';
import 'package:provider/provider.dart';

class RepoMenuBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RepoManager>(builder: (context, repoList, child) {
      return NoOverscrollGlow(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: ListView.builder(
            itemCount: repoList.repoCardList.length + 1,
            itemBuilder: (context, index) {
              if (index == repoList.repoCardList.length) {
                return Container(height: 50);
              }
              return repoList.repoCardList[index];
            },
          ),
        ),
      );
    });
  }
}
