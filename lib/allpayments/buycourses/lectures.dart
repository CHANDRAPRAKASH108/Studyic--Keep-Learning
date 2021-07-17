import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationstudyic/widget/slidefromleft.dart';
import 'package:educationstudyic/allpayments/buycourses/videoplayer.dart';

class Lectures extends StatefulWidget {
  String course_id;
  Lectures({required this.course_id});
  @override
  _LecturesState createState() => _LecturesState(course_id);
}

class _LecturesState extends State<Lectures> {
  String course_id;
  _LecturesState(this.course_id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lectures'),
        centerTitle: true,
      ),
      body: (FetchLectures(course_id)),
    );
  }
}

class FetchLectures extends StatefulWidget {
  String course_id;
  // ignore: use_key_in_widget_constructors
  FetchLectures(this.course_id);
  @override
  // ignore: no_logic_in_create_state
  _FetchLecturesState createState() => _FetchLecturesState(course_id);
}

class _FetchLecturesState extends State<FetchLectures> {
  String course_id;
  _FetchLecturesState(this.course_id);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Courses")
            .doc(course_id)
            .collection("Lectures")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            // ignore: curly_braces_in_flow_control_structures
            return const Center(child: CircularProgressIndicator());
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                  //color: Colors.grey[200],
                  ),
              //padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              margin: const EdgeInsets.only(bottom: 30.0),
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  var title = document['Title'];
                  var subtitle = document['Subtitle'];
                  var link = document['Link'];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(Icons.book,color: Colors.blue[900],),
                        title: Text(title),
                        subtitle: Text(subtitle),
                        trailing: Icon(Icons.play_arrow,color: Colors.blue[900],
                      ),
                      onTap: (){
                        Navigator.push(context, SlideFromLeft(widget: SamplePlayer(link: link,)));
                      },
                    )
                  ));
                }).toList(),
              ),
            ),
          );
        });
  }
}