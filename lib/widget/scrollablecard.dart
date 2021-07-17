import 'package:educationstudyic/widget/slidefromleft.dart';
import 'package:flutter/material.dart';
class ScrollableCard extends StatelessWidget {
  String _image;
  Widget widget;
  ScrollableCard(this._image,this.widget);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, SlideFromLeft(widget: widget));
      },
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage(_image),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}