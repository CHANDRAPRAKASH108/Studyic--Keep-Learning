import 'dart:async';
import 'package:educationstudyic/Teacher/assignmentlist.dart';
import 'package:educationstudyic/Teacher/scheduleassignment.dart';
import 'package:educationstudyic/Teacher/scheduleclass.dart';
import 'package:educationstudyic/Teacher/scheduledclasses.dart';
import 'package:educationstudyic/Teacher/searchandadd.dart';
import 'package:educationstudyic/Teacher/showdaylist.dart';
import 'package:educationstudyic/Teacher/teachershowpost.dart';
import 'package:intl/intl.dart';
import 'package:educationstudyic/Accountissue/accountissue.dart';
import 'package:educationstudyic/Result/mainpage.dart';
import 'package:educationstudyic/mentor/teacherside.dart';
import 'package:educationstudyic/notepad/shownotes.dart';
import 'package:educationstudyic/padllete/teacher.dart';
import 'package:educationstudyic/student/mypost.dart';
import 'package:educationstudyic/widget/slidefromleft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../aboutuspage.dart';
import '../selectuser.dart';
import 'listofstudent.dart';

var progressDialog;
DateTime initial = DateTime.now();
String currentday = '';

class ViewClasses extends StatefulWidget {
  String value, name, classday;
  ViewClasses(
      {required this.value, required this.name, required this.classday});
  @override
  _ViewClassesState createState() => _ViewClassesState(value, name, classday);
}

class _ViewClassesState extends State<ViewClasses> {
  String value = '', name = '', classday = '';
  String _timeString = '';
  _ViewClassesState(this.value, this.name, this.classday);
  @override
  void initState() {
    // TODO: implement initState
    _timeString = _formatDateTime(DateTime.now());
    initial = DateTime.now();
    setState(() {
      currentday = DateFormat('EEEE').format(initial);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    String greetingMessage() {
      var timeNow = DateTime.now().hour;

      if (timeNow <= 12) {
        return 'Good Morning';
      } else if ((timeNow > 12) && (timeNow <= 16)) {
        return 'Good Afternoon';
      } else if ((timeNow > 16) && (timeNow < 20)) {
        return 'Good Evening';
      } else {
        return 'Good Evening';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Studyic',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromRadius(
            MediaQuery.of(context).size.height * 0.1,
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: SizedBox(
                          child: Text(
                            greetingMessage() + "\n" + name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          ),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Text(
                        DateFormat('hh:mm a').format(DateTime.now()),
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                  child: Text(
                    'Your $currentday Scheduled Classes',
                    style: const TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01)
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage("assets/images/avtarback.jpg"),
                          ),
                          SizedBox(
                              child: Text(
                            name,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          )),
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.schedule,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Class Routine',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        SlideFromLeft(
                            widget: ShowDayList(
                          value: value,
                          name: name,
                        )));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.person_outline_outlined,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Mentor',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        SlideFromLeft(
                            widget: TeacherSideMentor(
                          id: value,
                        )));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.sports_soccer,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Social Media',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, SlideFromLeft(widget: TeacherShowPost()));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.link,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Results',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, SlideFromLeft(widget: MainPage()));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.assignment,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Notepad',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        SlideFromLeft(
                            widget: ShowNotes(
                          email: value,
                        )));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.question_answer,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Self Help Center',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, SlideFromLeft(widget: AccountIssue()));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.sports_soccer,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Studyic Media',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        SlideFromLeft(
                            widget: ShowStudentUploaded(
                          email: value,
                        )));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.description,
                    color: Colors.black,
                  ),
                  title: Text(
                    'About Us',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, SlideFromLeft(widget: ShowAbout()));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: ListTile(
                  leading: const Icon(
                    Icons.login,
                    color: Colors.black,
                  ),
                  title: Text(
                    'LogOut',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove("teacheremail");
                    prefs.remove("teachervalue");
                    prefs.remove("name");
                    prefs.remove("userType");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectUser(),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: (FetchDayClass(value, name, classday)),
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

class FetchDayClass extends StatefulWidget {
  String value, name, classday;
  FetchDayClass(this.value, this.name, this.classday);
  @override
  _FetchDayClassState createState() =>
      _FetchDayClassState(value, name, classday);
}

class _FetchDayClassState extends State<FetchDayClass> {
  String value, name, classday;
  _FetchDayClassState(this.value, this.name, this.classday);
  TextEditingController postcontroller = new TextEditingController();

  CreateAlertDialog(classname, id) {
    TextEditingController customcontroller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Enter Details'),
              content: Column(children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Your Id',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    emailstudent = customcontroller.text.toString();
                  },
                  controller: customcontroller,
                )
              ]),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    child: Text("Delete"),
                    onPressed: () async {
                      progressDialog.show();
                      progressDialog.update(message: "Deleting Class");
                      if (emailstudent == value) {
                        await FirebaseFirestore.instance
                            .collection(value)
                            .doc(id)
                            .delete();
                        await FirebaseFirestore.instance
                            .collection("Teacher")
                            .doc(value)
                            .collection(classday)
                            .doc(id)
                            .delete();
                        Fluttertoast.showToast(
                            msg: "Class Deleted Successfully",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            backgroundColor: Colors.black);
                        progressDialog.hide();
                        customcontroller.clear();
                      } else {
                        //progressDialog.hide();
                        Fluttertoast.showToast(
                            msg: "Please enter corect id",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            backgroundColor: Colors.black);
                      }
                    }),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Teacher")
            .doc(value)
            .collection(currentday)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: Text('No Classes Found'));
          return Container(
            child: ListView(
              children: snapshot.data!.docs.map((document) {
                var id = document.id;
                var classname = document['class_name'];
                return ListTile(
                  leading: Image.asset("assets/images/logo.png"),
                  title: Text(
                    classname,
                    style: TextStyle(
                        color: Colors.blue[900], fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Timing:- $id"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.blue[900],
                    onPressed: () {
                      CreateAlertDialog(classname, id);
                    },
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      backgroundColor: Colors.blue[900],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(45.0),
                            topRight: const Radius.circular(45.0)),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            //height: MediaQuery.of(context).size.height*0.5,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      'Schedule Classes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScheduleClass(
                                                    firstdata: classname,
                                                    seconddata: value,
                                                  )));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      'Scheduled Classes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScheduledClass(
                                                      subjectname: classname,
                                                      teacherid: value)));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.assignment,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      'Schedule Assignment',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: ScheduleAssignment(
                                            firstdata: classname,
                                            seconddata: value,
                                          )));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.assignment,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      'Scheduled Assignment',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: AssignmentList(
                                            subname: classname,
                                            mailId: value,
                                          )));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.question_answer,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      'Vote',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: CreatePadelete(
                                            subjectname: classname,
                                            teacherid: value,
                                          )));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.assignment,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      'Post',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      //sharePost(classname);
                                      showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.blue[900],
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(45.0),
                                              topRight:
                                                  const Radius.circular(45.0)),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              //height: MediaQuery.of(context).size.height*0.5,
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      const Text(
                                                        "Share Post",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0),
                                                      ),
                                                      const SizedBox(
                                                        height: 20.0,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                                  .only(
                                                              //bottom: MediaQuery.of(context).viewInsets.bottom
                                                              ),
                                                          child: TextField(
                                                            //style: TextStyle(color: Colors.white),
                                                            //cursorColor: Colors.white,
                                                            maxLines: 10,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  "Write Here",
                                                              fillColor:
                                                                  Colors.white,
                                                              filled: true,
                                                              //labelStyle: TextStyle(color: Colors.white),
                                                            ),
                                                            controller:
                                                                postcontroller,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                                .only(
                                                            //bottom: MediaQuery.of(context).viewInsets.bottom
                                                            ),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      value)
                                                                  .doc(
                                                                      classname)
                                                                  .collection(
                                                                      "Post")
                                                                  .doc()
                                                                  .set({
                                                                'post_link':
                                                                    postcontroller
                                                                        .text
                                                                        .toString()
                                                              });
                                                              // lastupdated(value,
                                                              //     classname);
                                                              postcontroller
                                                                  .clear();
                                                            },
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0)),
                                                            child: Text(
                                                              'Share Post',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .blue[
                                                                      900]),
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
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      'Add Student',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: SearchAndAdd(
                                            firstdata: classname,
                                            seconddata: value,
                                          )));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.supervisor_account_sharp,
                                      color: Colors.white,
                                    ),
                                    title: const Text(
                                      'List Of Student',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: StudentList(
                                            subjectname: classname,
                                            teacherid: value,
                                          )));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
          );
        });
  }
}
