import 'package:flutter/material.dart';

class NormalTextField extends StatelessWidget {
  final String labeltext;
  final TextEditingController fieldcontroller;
  bool obsecure;
  NormalTextField(
      this.labeltext,
      this.fieldcontroller,
      this.obsecure
      );
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      obscureText: obsecure,
      decoration: InputDecoration(
        labelText: labeltext,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      controller: fieldcontroller,
    );
  }
}
