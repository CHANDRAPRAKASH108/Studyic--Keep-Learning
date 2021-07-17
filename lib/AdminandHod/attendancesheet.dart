import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoIt extends StatelessWidget {
  String teacherid,subname,regd;
  DoIt({required this.teacherid,required this.subname,required this.regd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Sheet'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: (AttendanceSheet(teacherid,subname,regd,)),
    );
  }
}

class AttendanceSheet extends StatelessWidget {
  String teacherid,subname,regd;
  AttendanceSheet(this.teacherid,this.subname,this.regd);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(regd).doc(subname).collection("classes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            child: ListView(
              children: snapshot.data!.docs.map((document){
                bool attended = document['hasAttended'];
                var id = document.id;
                return ListTile(
                  leading: const Icon(Icons.person_outline_outlined),
                  title: Text(id),
                  subtitle: Text("Present:-"+attended.toString()),
                );
              }).toList(),
            ),
          );
        }
    );
  }
}
