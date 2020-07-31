import 'package:flutter/material.dart';
import 'package:jp_flashcard/dialogs/delete_tag_dialog.dart';

import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/managers/tag_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TagBox extends StatefulWidget {
  final String displayedString;
  bool canSelect;
  bool selected = false;
  TagBox({this.displayedString, this.canSelect, this.selected});

  @override
  _TagBoxState createState() => _TagBoxState();
}

class _TagBoxState extends State<TagBox> {
  Color backgroundColor = Colors.lightBlue[800];
  Color textColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    if (!widget.selected && widget.canSelect) {
      backgroundColor = Colors.white;
      textColor = Colors.lightBlue[800];
    } else {
      backgroundColor = Colors.lightBlue[800];
      textColor = Colors.white;
    }
    return Container(
      height: 25,
      child: ButtonTheme(
        minWidth: 0.0,
        height: 28,
        padding: widget.canSelect ? EdgeInsets.fromLTRB(14, 0, 7, 0) : EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: FlatButton(
          onPressed: () {
            if (widget.canSelect) {
              setState(() {
                widget.selected = !widget.selected;
              });
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.displayedString, style: TextStyle(color: textColor)),
              SizedBox(width: 2),
              widget.canSelect
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: PopupMenuButton<String>(
                        offset: Offset(50, 50),
                        onSelected: (String value) {
                          if (value == 'edit') {
                          } else if (value == 'delete') {
                            DeleteTagDialog.dialog(widget.displayedString)
                                .show(context)
                                .then((_) {
                              Provider.of<TagManager>(context, listen: false)
                                  .refresh();
                            });
                          }
                        },
                        child: Icon(
                          Icons.expand_more,
                          size: 15,
                          color: textColor,
                        ),
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text(DisplayedString.zhtw['edit'] ?? ''),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(DisplayedString.zhtw['delete'] ?? ''),
                            ),
                          ];
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(width: 1.5, color: Colors.lightBlue[800]),
          ),
          color: backgroundColor,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ),
    );
  }
}
