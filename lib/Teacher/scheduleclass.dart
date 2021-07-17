import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';

var link;
var classtitle;
var classsubtitle;
bool _isloading = false;
String dateis='';
var timestampdate;
var timestamptime;
var timeis;
var pd;
bool _isrecording = false;

class ScheduleClass extends StatefulWidget {
  var firstdata;
  var seconddata;
  ScheduleClass({this.firstdata, this.seconddata});
  @override
  _ScheduleClassState createState() =>
      _ScheduleClassState(firstdata, seconddata);
}

class _ScheduleClassState extends State<ScheduleClass> {
  var firstdata='';
  var seconddata='';

  _ScheduleClassState(this.firstdata, this.seconddata);

  late Future<void> _launched;

  String _launchurl = "https://zoom.us/";

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},);
    } else {
    }
  }

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    _launchInBrowser(_launchurl);
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime pickedDate = DateTime.now();
  late TimeOfDay time;
  TextEditingController uidcontroller = TextEditingController();
  TextEditingController classtitlecontroller = TextEditingController();
  TextEditingController classsubtitlecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Meeting'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: (Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                    labelText: "Paste link here", border: OutlineInputBorder()),
                onChanged: (text) {
                  setState(() {
                    link = uidcontroller.text.toString();
                  });
                },
                controller: uidcontroller,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Enter Title", border: OutlineInputBorder()),
                onChanged: (text) {
                  setState(() {
                    classtitle = classtitlecontroller.text.toString();
                  });
                },
                controller: classtitlecontroller,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Enter Subtitle", border: OutlineInputBorder()),
                onChanged: (text) {
                  setState(() {
                    classsubtitle = classsubtitlecontroller.text.toString();
                  });
                },
                controller: classsubtitlecontroller,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                "Select Class Starting time",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.04),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Column(children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: CupertinoDatePicker(
                    onDateTimeChanged: (dateTime) {
                      setState(() {
                        pickedDate = dateTime;
                      });
                    },
                    initialDateTime: pickedDate,
                  ),
                )
              ]),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: RaisedButton(
                  onPressed: () async {
                    progressDialog.show();
                    progressDialog.update(message: "Scheduling Class");
                    Timestamp myTimeStamp = Timestamp.fromDate(pickedDate);
                    // DocumentReference messageRef = db .collection("rooms").document("roomA") .collection("messages").document("message1");
                    await FirebaseFirestore.instance
                        .collection(seconddata)
                        .doc(firstdata)
                        .collection("classes")
                        .doc(classtitle)
                        .set({
                      'Class_link': link,
                      'Class_title': classtitle,
                      'Class_Subtitle': classsubtitle,
                      'time':
                      time.hour.toString() + ":" + time.minute.toString(),
                      'date': pickedDate.day.toString() +
                          "-" +
                          pickedDate.month.toString() +
                          "-" +
                          pickedDate.year.toString(),
                      'Timestamp': myTimeStamp
                    }).then((onValue) {
                    }).catchError((e) {

                    });
                    final userref = FirebaseFirestore.instance
                        .collection(seconddata)
                        .doc(firstdata)
                        .collection(seconddata)
                        .get()
                        .then((QuerySnapshot snapshot) {
                      snapshot.docs.forEach((doc) {
                        String registration = doc.id;
                        final databaseref = FirebaseDatabase.instance
                            .reference()
                            .child(seconddata)
                            .child(firstdata)
                            .child(registration)
                            .child(
                          pickedDate.day.toString() +
                              "-" +
                              pickedDate.month.toString() +
                              "-" +
                              pickedDate.year.toString() +
                              "_" +
                              time.hour.toString() +
                              ":" +
                              time.minute.toString(),
                        )
                            .set({'hasAttended': false});
                      });
                    });
                    //lastupdated(seconddata, firstdata);
                    progressDialog.hide();
                    Fluttertoast.showToast(
                        msg: "Class scheduled successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.green,
                        backgroundColor: Colors.black);
                    classsubtitlecontroller.clear();
                    classtitlecontroller.clear();
                    uidcontroller.clear();
                  },
                  color: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    'Submit Class Info',
                    style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),
                  ),
                ),
              ),
            ],
          ),
        )
        ),
      ),
    );
  }
}
