import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  String _subname;
  SubjectTile(
      this._subname
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height*0.15,
      margin: const EdgeInsets.symmetric(
          vertical: 10,horizontal: 10.0
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(
            color: Theme.of(context).primaryColor,
            blurRadius: 5.0
        )],
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/25),
              alignment: Alignment.centerLeft,
              //height: 60,
              width: MediaQuery.of(context).size.width*0.2,
              child: const Image(
                image: AssetImage("assets/images/logo.png"),
              )
          ),
          SizedBox(
            child: Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/25),
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                _subname,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width*0.04),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
