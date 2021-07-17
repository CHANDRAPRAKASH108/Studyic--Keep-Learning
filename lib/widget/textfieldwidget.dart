import 'package:flutter/material.dart';
class TextFieldWidget extends StatelessWidget {
  String labeltext;
  TextEditingController _fieldcontroller;
  bool obsecure;
  TextFieldWidget(
      this.labeltext,
      this._fieldcontroller,
      this.obsecure
      );
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labeltext,
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      obscureText: obsecure,
      controller: _fieldcontroller,
    );
  }
}
