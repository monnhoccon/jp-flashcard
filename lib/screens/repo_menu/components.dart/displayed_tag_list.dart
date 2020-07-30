import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_displaying_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DisplayedTagBoxList extends StatelessWidget {
  //ANCHOR Initialize displayed tag list
  List<Widget> displayedTagList = [];
  void _initDisplayedTagList(RepoInfo repoInfo) {
    displayedTagList.clear();
    displayedTagList.add(
      Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Icon(
          Icons.label_outline,
          size: 15,
        ),
      ),
    );
    for (final tag in repoInfo.tagList) {
      displayedTagList.add(
        Text(
          tag == repoInfo.tagList.last ? tag + ' ' : tag + ', ',
          style: TextStyle(fontSize: 12),
        ),
      );
    }
  }

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    return Consumer2<RepoInfo, RepoDisplayingSettings>(
      builder: (context, repoInfo, repoDisplayingSettings, child) {
        //ANCHOR Initialized
        _initDisplayedTagList(repoInfo);

        //ANCHOR Displayed tag list
        return repoInfo.tagList.isNotEmpty && repoDisplayingSettings.displayTag
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    color: Colors.black,
                    height: 0,
                    thickness: 0.3,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 7, 10, 10),
                    child: Wrap(
                      spacing: 0,
                      children: displayedTagList,
                    ),
                  )
                ],
              )
            : Container();
      },
    );
  }
}
