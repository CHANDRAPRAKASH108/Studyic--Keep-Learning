import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:educationstudyic/widget//slidefromleft.dart';
import 'package:educationstudyic/allpayments/buycourses/lectures.dart';

String regd="regd";
String course_id="course_id";
class GetCourses extends StatefulWidget {
  @override
  _GetCoursesState createState() => _GetCoursesState();
}

class _GetCoursesState extends State<GetCourses> {
  getdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      regd = prefs.getString("regd_no")!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Courses'),
        centerTitle: true,
      ),
      body: (FetchCourses(course_id)),
    );
  }
}

class FetchCourses extends StatefulWidget {
  String course_id;
  FetchCourses(this.course_id);
  @override
  _FetchCoursesState createState() => _FetchCoursesState(course_id);
}

class _FetchCoursesState extends State<FetchCourses> {
  String course_id;
  _FetchCoursesState(this.course_id);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Student")
            .doc(regd)
            .collection("Courses")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                  //color: Colors.grey[200],
                  ),
              //padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              margin: EdgeInsets.only(bottom: 30.0),
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  var coursename = document['course_name'];
                  var teachername = document['teacher_name'];
                  var description = document['description'];
                  var img = document['img'];
                  var course_id = document['course_id'];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.blue[900]),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.2),
                                  BlendMode.dstATop),
                              image: const AssetImage("assets/images/yourcourses.jpg"),
                              fit: BoxFit.cover)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[900],
                          backgroundImage: NetworkImage(img),
                          radius: 35.0,
                        ),
                        title: Text(coursename),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "By:-" + teachername,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              "Description:-" + description,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, SlideFromLeft(widget: Lectures(course_id: course_id,)));
                                  },
                                  child: const Text(
                                    'Watch Lectures',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Theme.of(context).primaryColor)),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}
