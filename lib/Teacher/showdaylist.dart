import 'dart:async';
import 'package:educationstudyic/Teacher/viewother.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String currentday='';
String time='';

class ShowDayList extends StatefulWidget {
  String value, name;
  ShowDayList({required this.value, required this.name});
  @override
  _ShowDayListState createState() => _ShowDayListState(value, name);
}

DateTime initial = DateTime.now();

class _ShowDayListState extends State<ShowDayList> {
  String value='', name='';
  String _timeString='', _currentday='';
  _ShowDayListState(this.value, this.name);
  @override
  void initState() {
    // TODO: implement initState
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    initial = DateTime.now();
    _currentday = DateFormat('EEEE').format(initial);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    TextEditingController classnamecontroller = new TextEditingController();
    TextEditingController timecontroller = new TextEditingController();
    AddEvent(String currentday) {
      showModalBottomSheet<void>(
        backgroundColor: Colors.blue[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.0),
              topRight: Radius.circular(45.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        "Create Event",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            //bottom: MediaQuery.of(context).viewInsets.bottom
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Enter Class Name",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            controller: classnamecontroller,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            //bottom: MediaQuery.of(context).viewInsets.bottom
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Enter Timing",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            controller: timecontroller,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            //bottom: MediaQuery.of(context).viewInsets.bottom
                          ),
                          child: RaisedButton(
                            onPressed: () async {
                              DateTime currentPhoneDate =
                              DateTime.now(); //DateTime

                              Timestamp myTimeStamp = Timestamp.fromDate(
                                  currentPhoneDate); //To TimeStamp

                              await FirebaseFirestore.instance
                                  .collection("Teacher")
                                  .doc(value)
                                  .collection(currentday)
                                  .doc(timecontroller.text.toString())
                                  .set({
                                'class_name':
                                classnamecontroller.text.toString(),
                              });
                              await FirebaseFirestore.instance
                                  .collection(value)
                                  .doc(classnamecontroller.text.toString())
                                  .set({
                                'Test Data': 'nothing',
                                'last_updated': myTimeStamp
                              });
                              classnamecontroller.clear();
                              timecontroller.clear();
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.blue[900]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    //initial = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Calendar'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            //height: MediaQuery.of(context).size.height*1.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: const SizedBox(
                    height: 25.0,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 5.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Image(
                    height: MediaQuery.of(context).size.height * 0.2,
                    image: AssetImage('assets/images/studyic.png'),
                  ),
                ),
                Container(
                  child: const SizedBox(
                    height: 25.0,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Date:- ${initial.day.toString() + "-" + initial.month.toString() + "-" + initial.year.toString()}",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(
                        "Time:- $_timeString",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                Text(
                  "Day:- $_currentday",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: const SizedBox(
                    height: 50.0,
                  ),
                ),
                ExpansionTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(
                    "Monday",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          AddEvent(currentday = "Monday");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "Create Class",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOther(
                                      value: value,
                                      name: name,
                                      classday: "Monday")));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "View Classes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(
                    "Tuesday",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          AddEvent(currentday = "Tuesday");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "Create Class",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOther(
                                      value: value,
                                      name: name,
                                      classday: "Tuesday")));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "View Classes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(
                    "Wednesday",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          AddEvent(currentday = "Wednesday");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "Create Class",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOther(
                                      value: value,
                                      name: name,
                                      classday: "Wednesday")));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "View Classes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(
                    "Thursday",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          AddEvent(currentday = "Thursday");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "Create Class",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOther(
                                      value: value,
                                      name: name,
                                      classday: "Thursday")));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "View Classes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(
                    "Friday",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          AddEvent(currentday = "Friday");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "Create Class",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOther(
                                      value: value,
                                      name: name,
                                      classday: "Friday")));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "View Classes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(
                    "Saturday",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          AddEvent(currentday = "Saturday");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "Create Class",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOther(
                                      value: value,
                                      name: name,
                                      classday: "Saturday")));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "View Classes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(
                    "Sunday",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          AddEvent(currentday = "Sunday");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "Create Class",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOther(
                                      value: value,
                                      name: name,
                                      classday: "Sunday")));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        child: const Text(
                          "View Classes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }
}
