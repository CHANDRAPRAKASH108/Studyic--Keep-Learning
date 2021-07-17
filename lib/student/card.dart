import 'package:educationstudyic/widget/slidefromleft.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  String _img;
  Widget widget;
  StudentCard(this._img,this.widget);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, SlideFromLeft(widget: widget));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height*0.25,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor,
                offset: Offset(5.0, 5.0),
                blurRadius: 5.0,
                spreadRadius: 5.0,
              ),
            ],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            //border: Border.all(color: Colors.blue[900]),
            image: DecorationImage(
              image: AssetImage(_img),
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
