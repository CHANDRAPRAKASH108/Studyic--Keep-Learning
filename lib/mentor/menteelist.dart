import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class MenteeList extends StatefulWidget {
  String id;
  MenteeList({required this.id});
  @override
  _MenteeListState createState() => _MenteeListState(id);
}

class _MenteeListState extends State<MenteeList> {
  String id;
  _MenteeListState(this.id);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentee List'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: (ShowMenteeList(id)),
    );
  }
}

class ShowMenteeList extends StatelessWidget {
  String id;
  ShowMenteeList(this.id);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Mentor").doc("Mentee").collection(id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document){
                String studentemail = document.id;
                return  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(width: 2,color: Colors.lightBlueAccent)
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                      },
                      child: Container(
                        height: 70,
                        child: new Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 35, left: 30),
                                child: new Column(
                                  children: <Widget>[
                                    new Text(studentemail, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),overflow: TextOverflow.fade,),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    )
                );
              }).toList(),
            ),
          );
        }
    );
  }
}

