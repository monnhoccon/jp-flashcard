import 'package:flutter/material.dart';
import 'package:jp_flashcard/screen/repo/widget/input_field.dart';
import 'package:jp_flashcard/screen/repo/widget/definition_input.dart';

// ignore: must_be_immutable
class AddFlashcard extends StatefulWidget {
  @override
  _AddFlashcardState createState() => _AddFlashcardState();
}

class _AddFlashcardState extends State<AddFlashcard> {
  //ANCHOR Variables
  Map _displayedStrinZHTW = {
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
  List<Widget> flashcardList = [];
  final wordFormKey = GlobalKey<FormState>();

  int numDefinition = 1;
  List<GlobalKey<FormState>> definitionFormKey = [
    GlobalKey<FormState>(),
  ];
  List<TextEditingController> definitionValue = [TextEditingController()];
  List<Widget> definitionInputField = [];

  String dropdownValue;
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_displayedStrinZHTW['add flashcard'] ?? ''),
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
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(30),
                      width: 350,
                      //height: 500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _displayedStrinZHTW['word'] ?? '',
                            style: Theme.of(context).textTheme.overline,
                          ),
                          InputField(
                            validationKey: wordFormKey,
                            value: textController,
                            errorMessage:
                                _displayedStrinZHTW['word error'] ?? '',
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            _displayedStrinZHTW['definition'] ?? '',
                            style: Theme.of(context).textTheme.overline,
                          ),
                          DefinitionInput(
                            validationKey: definitionFormKey[0],
                            value: definitionValue[0],
                          ),
                          ...definitionInputField,
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
                                          definitionInputField.removeLast();
                                          definitionFormKey.removeLast();
                                          definitionValue.removeLast();
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(Icons.delete_outline),
                                          Text(_displayedStrinZHTW[
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
                                      definitionInputField.add(Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 8, 0, 0),
                                        child: DefinitionInput(
                                          validationKey: definitionFormKey[
                                              numDefinition - 1],
                                          value: definitionValue[
                                              numDefinition - 1],
                                        ),
                                      ));
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.add),
                                      Text(_displayedStrinZHTW[
                                              'add definition'] ??
                                          '')
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      )),
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
            if (validation) {
              Navigator.of(context).pop();
            }
          }),
    );
  }
}
