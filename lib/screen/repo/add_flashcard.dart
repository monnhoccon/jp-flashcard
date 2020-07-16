import 'package:flutter/material.dart';
import 'package:jp_flashcard/screen/main_menu/widgets/tag_box.dart';
import 'package:jp_flashcard/screen/repo/widget/add_word_type_dialog.dart';
import 'package:jp_flashcard/screen/repo/widget/definition_input.dart';
import 'package:jp_flashcard/screen/repo/widget/kanji_input.dart';
import 'package:jp_flashcard/screen/repo/widget/word_input.dart';
import 'package:jp_flashcard/utils/jp_letter.dart';

// ignore: must_be_immutable
class AddFlashcard extends StatefulWidget {
  @override
  _AddFlashcardState createState() => _AddFlashcardState();
}

class _AddFlashcardState extends State<AddFlashcard> {
  //ANCHOR Variables
  Map _displayedStringZHTW = {
    'add flashcard': '新增單字卡',
    'word': '單字',
    'definition': '定義',
    'type': '詞性',
    'kanji': '漢字讀音',
    'word error': '請輸入單字',
    'definition error': '請輸入定義',
    'add definition': '新增定義',
    'delete definition': '刪除定義'
  };

  //ANCHOR Word
  final wordFormKey = GlobalKey<FormState>();
  TextEditingController wordValue = TextEditingController();
  //================================

  //ANCHOR Definition
  int numDefinition = 1;
  List<TextEditingController> definitionValue = [TextEditingController()];
  List<GlobalKey<FormState>> definitionFormKey = [GlobalKey<FormState>()];
  List<Widget> definitionInputList = [];
  //================================

  //ANCHOR Kanji
  int numKanji = 0;
  List<TextEditingController> kanjiValue = [];
  List<GlobalKey<FormState>> kanjiFormKey = [];
  List<Widget> kanjiInputList = [];

  void parseKanji(String text) {
    setState(() {
      kanjiInputList.clear();
      for (int i = 0; i < text.length; i++) {
        var char = text[i];
        bool isKanji = true;
        for (final letter in JPLetter.letterList) {
          if (char == letter) {
            isKanji = false;
            break;
          }
        }
        if (isKanji) {
          kanjiFormKey.add(GlobalKey<FormState>());
          kanjiValue.add(TextEditingController());
          kanjiInputList.add(KanjiInput(
            displayedString: char,
            value: kanjiValue[numKanji],
            validationKey: kanjiFormKey[numKanji],
          ));
          numKanji++;
        }
      }
    });
  }
  //================================

  //ANCHOR Word type
  List<TagBox> selectedWordTypeBoxList = [];
  void applySelection(List<TagBox> newSelectedWordTypeBoxList) {
    setState(() {
      selectedWordTypeBoxList = newSelectedWordTypeBoxList;
    });
  }

  Future<void> addWordTypeDialog(BuildContext context) async {
    AddWordTypeDialog addWordTypeDialog = AddWordTypeDialog(
        selectedWordTypeBoxList: selectedWordTypeBoxList,
        applySelection: applySelection);
    await addWordTypeDialog.dialog(context);
  }

  void updateSelectedWordTypeList() {
    List<Widget> newWordTypeBoxList = List.from(selectedWordTypeBoxList);
    newWordTypeBoxList.add((Container(
        height: 25,
        child: ButtonTheme(
          minWidth: 5.0,
          height: 28.0,
          child: FlatButton(
            onPressed: () async {
              await addWordTypeDialog(context);
              setState(() {});
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.add,
                  size: 15,
                  color: Colors.white,
                ),
                SizedBox(width: 2),
                Text(
                  _displayedStringZHTW['add word type'] ?? '',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: Theme.of(context).primaryColor,
          ),
        ))));
    setState(() {
      selectedWordTypeBoxList = newWordTypeBoxList;
    });
  }
  //================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_displayedStringZHTW['add flashcard'] ?? ''),
      ),
      body: Center(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 450),
                  child: Card(
                    child: Container(
                        padding: EdgeInsets.all(30),
                        width: 350,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            WordInput(
                              validationKey: wordFormKey,
                              value: wordValue,
                              displayedString:
                                  _displayedStringZHTW['word'] ?? '',
                              parseKanji: parseKanji,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            DefinitionInput(
                              validationKey: definitionFormKey[0],
                              value: definitionValue[0],
                              displayedString:
                                  (_displayedStringZHTW['definition'] ?? '') +
                                      ((numDefinition > 1) ? '1' : ''),
                            ),
                            ...definitionInputList,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                numDefinition != 1
                                    ? FlatButton(
                                        padding: EdgeInsets.all(0),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        onPressed: () {
                                          setState(() {
                                            numDefinition--;
                                            definitionInputList.removeLast();
                                            definitionFormKey.removeLast();
                                            definitionValue.removeLast();
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(Icons.delete_outline),
                                            Text(_displayedStringZHTW[
                                                    'delete definition'] ??
                                                '')
                                          ],
                                        ))
                                    : Container(),
                                FlatButton(
                                    padding: EdgeInsets.all(0),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onPressed: () {
                                      setState(() {
                                        numDefinition++;
                                        definitionFormKey
                                            .add(GlobalKey<FormState>());
                                        definitionValue
                                            .add(TextEditingController());
                                        definitionInputList.add(Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 4, 0, 0),
                                          child: DefinitionInput(
                                            validationKey: definitionFormKey[
                                                numDefinition - 1],
                                            value: definitionValue[
                                                numDefinition - 1],
                                            displayedString:
                                                (_displayedStringZHTW[
                                                            'definition'] ??
                                                        '') +
                                                    (numDefinition.toString()),
                                          ),
                                        ));
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.add),
                                        Text(_displayedStringZHTW[
                                                'add definition'] ??
                                            '')
                                      ],
                                    )),
                              ],
                            ),
                            numKanji > 0
                                ? Text(
                                    '漢字' ?? '',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )
                                : Container(),
                            Container(
                                height: 200,
                                child: Wrap(
                                  children: kanjiInputList,
                                ))
                          ],
                        )),
                  ),
                )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            bool validation = true;
            if (!wordFormKey.currentState.validate()) {
              validation = false;
            }
            for (final formKey in definitionFormKey) {
              if (!formKey.currentState.validate()) {
                validation = false;
              }
            }
            for (final formKey in kanjiFormKey) {
              if (!formKey.currentState.validate()) {
                validation = false;
              }
            }
            if (validation) {
              Navigator.of(context).pop();
            }
          }),
    );
  }
}
