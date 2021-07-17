import 'package:educationstudyic/Teacher/assignmentlist.dart';
import 'package:educationstudyic/Teacher/scheduleassignment.dart';
import 'package:educationstudyic/Teacher/scheduleclass.dart';
import 'package:educationstudyic/Teacher/searchandadd.dart';
import 'package:educationstudyic/padllete/teacher.dart';
import 'package:educationstudyic/widget/slidefromleft.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:educationstudyic/Teacher/scheduledclasses.dart';

import 'listofstudent.dart';

String emailstudent = '';
var progressDialog;

class ViewOther extends StatefulWidget {
  String value, name, classday;
  // ignore: use_key_in_widget_constructors
  ViewOther({required this.value, required this.name, required this.classday});
  @override
  _ViewOtherState createState() => _ViewOtherState(value, name, classday);
}

class _ViewOtherState extends State<ViewOther> {
  String value, name, classday;
  _ViewOtherState(this.value, this.name, this.classday);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Classes'),
        centerTitle: true,
      ),
      body: FetchDayClass(value, name, classday),
    );
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
                    child: const Text("Delete"),
                    onPressed: () async {
                      progressDialog.show();
                      progressDialog.update(message: "Deleting Class");
                      if (emailstudent == value) {
                        await FirebaseFirestore.instance
                            .collection(value)
                            .doc(classname)
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
            .collection(classday)
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
                                      //Navigator.pop(context);
                                      Navigator.pushReplacement(
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
