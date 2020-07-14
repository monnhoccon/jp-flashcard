import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screen/repo/add_flashcard.dart';
import 'package:jp_flashcard/screen/repo/test.dart';

class Repo extends StatefulWidget {
  RepoInfo repoInfo;
  Repo({this.repoInfo});
  @override
  _RepoState createState() => _RepoState();
}

class _RepoState extends State<Repo> {
  //ANCHOR Variables
  List<Widget> flashcardList = [];

  String t = 'a';
  void pressed(String str) {
    setState(() {
      t = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.repoInfo.title),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          //ANCHOR Repo info
          Text('hi'),
          Text('hey'),
          //ANCHOR Flashcard card list
          Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return false;
                  },
                  child: ListView.builder(
                      itemCount: flashcardList.length,
                      itemBuilder: (context, index) {
                        return flashcardList[index];
                      }))),
        ],
      )),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddFlashcard();
        }));
      }),
    );
  }
}
