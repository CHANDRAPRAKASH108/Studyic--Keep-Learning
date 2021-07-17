import 'package:educationstudyic/student/classes/attendance.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'assignmentlist.dart';

class StudentList extends StatefulWidget {
  String subjectname,teacherid;
  StudentList({required this.subjectname,required this.teacherid});
  @override
  _StudentListState createState() => _StudentListState(subjectname,teacherid);
}

class _StudentListState extends State<StudentList> {
  String subjectname,teacherid;
  _StudentListState(this.subjectname,this.teacherid);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Student"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowStudent(subjectname,teacherid)),
    );
  }
}

class ShowStudent extends StatefulWidget {
  @override
  String subjectname,teacherid;
  ShowStudent(this.subjectname,this.teacherid);
  _ShowStudentState createState() => _ShowStudentState(subjectname,teacherid);
}

class _ShowStudentState extends State<ShowStudent> {
  String subjectname,teacherid;
  _ShowStudentState(this.subjectname,this.teacherid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(teacherid).doc(subjectname).collection(teacherid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return Container(
            child: ListView(
              children: snapshot.data!.docs.map((document){
                String studentemail = document.id;
                return  Card(
                    elevation: 5,
                    shadowColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                      },
                      child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(studentemail, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035, fontWeight: FontWeight.bold),overflow: TextOverflow.fade,),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: const EdgeInsets.only(left: 10),
                                      child:  RaisedButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Attendance(subName: subjectname,mailId: studentemail,teacherid: teacherid,)));
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => new ShowPdf(value: pdflink,)));
                                      },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        child: Text("Attendance", style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: const EdgeInsets.only(left: 10),
                                      child: RaisedButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AssignmentList(mailId: studentemail, subname: subjectname)));
                                      },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        child: Text("Assignment", style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),),
                                      ),
                                    ),
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

