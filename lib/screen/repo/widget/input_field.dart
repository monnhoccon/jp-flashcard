import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final validationKey;
  final String errorMessage;
  final TextEditingController value;
  InputField({
      this.value,
      this.validationKey,
      this.errorMessage});
  @override
  
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Form(
          key: validationKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 80
            ),
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
                errorStyle: TextStyle(fontSize: 0, height: 0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                        width: 1.5, color: Colors.lightBlue[800])),
              ),
              controller: value,
              validator: (value) {
                if (value.isEmpty) {
                  return errorMessage ?? '';
                }
                return null;
              },
            ),
          )),
    );
  }
}
