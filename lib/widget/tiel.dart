import 'package:educationstudyic/widget/slidefromleft.dart';
import 'package:flutter/material.dart';
class ListTiel extends StatelessWidget {
  Widget widget;
  String titletxt;
  var icon;
  ListTiel({required this.widget,required this.titletxt,this.icon});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: SizedBox(
        //height: MediaQuery.of(context).size.height*0.07,
        child: Text(
          titletxt,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context, SlideFromLeft(widget: widget));
      },
    );
  }
}
