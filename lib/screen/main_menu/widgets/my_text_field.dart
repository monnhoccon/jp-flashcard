import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final formKey;
  final String displayedString;
  final String errorMessage;
  final TextEditingController textController;
  MyTextField(
      {this.displayedString,
      this.textController,
      this.formKey,
      this.errorMessage});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(displayedString, style: Theme.of(context).textTheme.overline),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Form(
              key: formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          BorderSide(width: 1.5, color: Colors.lightBlue[800]),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                            width: 1.5, color: Colors.lightBlue[800])),
                  ),
                  controller: textController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return errorMessage;
                    }
                    return null;
                  },
                ),
              )),
        )
      ],
    );
  }
}
