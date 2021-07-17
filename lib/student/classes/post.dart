import 'package:educationstudyic/padllete/student.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import 'assignement.dart';
import 'attendance.dart';
import 'myclasses.dart';
class Posts extends StatelessWidget {
  String mailId;
  String subName,teacherid;
  Posts({required this.mailId, required this.subName,required this.teacherid});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(teacherid)
              .doc(subName)
              .collection('Post')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child:  CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              );
            }
            return Container(
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  String post = document['post_link'];
                  return Container(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Theme.of(context).primaryColor)
                          ),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Container(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              post,
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, color: Colors.blue[900]),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.subject),
        closedForegroundColor: Colors.white,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.blue[900],
        openBackgroundColor: Colors.blue[900],
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.calendar_today),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Scheduled Classes',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ScheduledClass(subname: subName,mailId: mailId,teacherid: teacherid)));
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.assignment),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Assignment',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Assignment(subName: subName,userEmailId: mailId,teacherid: teacherid)));
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.person),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Attendance',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Attendance(subName: subName,mailId: mailId,teacherid: teacherid,)));
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.question_answer),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Vote',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentPadellete(mailId: mailId,subName: subName,teacherid: teacherid)));
            },
          ),
          //  Your other SpeeDialChildren go here.
        ],
      ),
    );
  }
}
