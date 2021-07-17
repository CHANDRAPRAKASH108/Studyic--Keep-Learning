import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'attendancesheet.dart';

class VisitClass extends StatefulWidget {
  String regd;
  VisitClass({required this.regd});
  @override
  _VisitClassState createState() => _VisitClassState(regd);
}

class _VisitClassState extends State<VisitClass> {
  String regd;
  _VisitClassState(this.regd);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(regd),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (FetchClasses(regd)),
    );
  }
}

class FetchClasses extends StatelessWidget {
  String regd;
  FetchClasses(this.regd);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(regd)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new CircularProgressIndicator();
          return  Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
            //margin: EdgeInsets.only(bottom: 15.0),
            child: ListView(
              primary: true,
              children: snapshot.data!.docs.map((document) {
                var subName = document.id;
                var teacherid = document['Teacher Id'];
                return ListTile(
                  leading: const Image(image: AssetImage("assets/images/logo.png"),),
                  title: Text(subName),
                  onTap: (){
                    print(subName);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DoIt(teacherid: teacherid,regd: regd,subname: subName)));
                  },
                );
              }).toList(),
            ),
          );
        });
  }
}

