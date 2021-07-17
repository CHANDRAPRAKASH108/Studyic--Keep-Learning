import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationstudyic/Teacher/showpdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
var sssubjectname;
var ssteacherid;
var sslink;

class SeeAssignments extends StatefulWidget {
  var subjectname;
  var teacherid;

  SeeAssignments({this.subjectname,this.teacherid});
  @override
  _SeeAssignmentsState createState() => _SeeAssignmentsState(subjectname,teacherid);
}

class _SeeAssignmentsState extends State<SeeAssignments> {
  var subjectname='';
  var teacherid='';

  _SeeAssignmentsState(this.subjectname, this.teacherid);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    FirebaseFirestore.instance
        .collection(teacherid.toString())
        .doc(subjectname.toString())
        .collection("Assignment")
        .get()
        .then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
       
      }),
    });
    ssteacherid = teacherid.toString();
    sssubjectname = subjectname.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Given Assignments'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowClasses()),
    );
  }
}

class ShowClasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("7543").doc("Data Mining and Data Warehouse").collection("Assignment").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document){
                var value = document['Assignment_title'];
                var sub = document['Assignment_Subtitle'];
                var samay = document['Assignment_Deadline'];
                var kabtaksamay = document['Assignment_Time'];
                var id = document.id;
                var assignlink = document['Assignment_Link'];

                //subname=document.id;
                return Card(
                    shadowColor: Colors.lightBlueAccent,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                        child: Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top: 35, left: 30),
                                child: Column(
                                  children: <Widget>[
                                    Text(value, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                                    Text(sub, style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    Text("Deadline :- $samay      $kabtaksamay", style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: const EdgeInsets.only(left: 10),
                                      child: RaisedButton(onPressed:
                                          (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => ShowPdf(value: assignlink)));
                                      },
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: const Text("See Assignment", style: TextStyle(color: Colors.white),),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    );
              }).toList(),
            ),
          );
        }
    );
  }
}

