import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationstudyic/Teacher/editclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

var sssubjectname;
var ssteacherid;
var sslink;

class ScheduledClass extends StatefulWidget {
  var subjectname;
  var teacherid;
  ScheduledClass({this.subjectname, this.teacherid});
  @override
  _ScheduledClassState createState() =>
      _ScheduledClassState(subjectname, teacherid);
}

class _ScheduledClassState extends State<ScheduledClass> {
  var subjectname;
  var teacherid;

  _ScheduledClassState(this.subjectname, this.teacherid);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    FirebaseFirestore.instance
        .collection(teacherid.toString())
        .doc(subjectname.toString())
        .collection("classes")
        .orderBy("Timestamp")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {}),
            });
    ssteacherid = teacherid.toString();
    sssubjectname = subjectname.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your scheduled classes'),
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
    late Future<void> _launched;

    String _launchurl = "https://zoom.us/";

    Future<void> _launchInBrowser(String url) async {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
          headers: <String, String>{'header_key': 'header_value'},
        );
      } else {}
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(ssteacherid)
            .doc(sssubjectname)
            .collection("classes")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: new CircularProgressIndicator());
          return Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document) {
                var value = document['Class_title'];
                var sub = document['Class_Subtitle'];
                var classlink = document['Class_link'];
                var samay = document['date'];
                var time = document['time'];

                //subname=document.id;
                return Card(
                    //color: Colors.lightBlueAccent,
                    shadowColor: Colors.lightBlueAccent,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      //side: BorderSide(width: 5,color: Colors.black54)
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => new ClassHome(value: value, id: coll)));
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          Container(
                            //margin: const EdgeInsets.only(top: 35, left: 30),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  value,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  sub,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Scheduled On:- $samay",
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Time :- $time",
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                //new Text(classlink, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: RaisedButton(
                                    onPressed: () {
                                      _launchInBrowser(classlink);
                                    },
                                    elevation: 10,
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const Text(
                                      "Join Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> EditClass(teacherid: ssteacherid,subject: sssubjectname,title: value,subtitle: sub)));
                                    },
                                    elevation: 10,
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const Text(
                                      "Edit Detail",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ));
              }).toList(),
            ),
          );
        });
  }
}
