import 'package:educationstudyic/Teacher/showpdf.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

String postcontent='';
class AssignmentList extends StatefulWidget {
  String subname, mailId;
  AssignmentList({required this.subname, required this.mailId});
  @override
  _AssignmentListState createState() => _AssignmentListState(subname, mailId);
}

class _AssignmentListState extends State<AssignmentList> {
  String subname, mailId;
  _AssignmentListState(this.subname, this.mailId);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assignments',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: (ShowAssignment(subname, mailId)),
    );
  }
}

class ShowAssignment extends StatefulWidget {
  String subname, mailId;
  ShowAssignment(this.subname, this.mailId);
  @override
  _ShowAssignmentState createState() => _ShowAssignmentState(subname, mailId);
}

class _ShowAssignmentState extends State<ShowAssignment> {
  String subname, mailId;
  _ShowAssignmentState(this.subname, this.mailId);
  @override
  Widget build(BuildContext context) {
    AddScore(String title) {
      TextEditingController postcontroller = TextEditingController();
      return showDialog(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Enter Details'),
                content: Column(children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Write here",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      postcontent = postcontroller.text.toString();
                    },
                    controller: postcontroller,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ]),
                actions: <Widget>[
                  MaterialButton(
                      elevation: 5.0,
                      child: const Text("Assign score"),
                      onPressed: () async {
                        // ProgressDialog progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal,isDismissible: false);

                        if (postcontent != null) {
                          FirebaseFirestore.instance
                              .collection(mailId)
                              .doc(subname)
                              .collection("upload")
                              .doc(title)
                              .update({'score': postcontent});

                          postcontroller.clear();
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: "Score assigned successfully...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.green,
                              backgroundColor: Colors.black);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please write something",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.red,
                              backgroundColor: Colors.black);
                        }
                      }),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  )
                ],
              ),
            );
          });
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(mailId)
            .doc(subname)
            .collection("upload")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document) {
                var link = document['Uploaded link'];
                var title = document.id;
                return Card(
                    shadowColor: Colors.lightBlueAccent,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => new ClassHome(value: value, id: coll)));
                      },
                      child: Container(
                        height: 160,
                        child: Row(children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 35, left: 30),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.7,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                           MaterialPageRoute(
                                              builder: (context) => ShowPdf(value: link)));
                                    },
                                    elevation: 10,
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const Text(
                                      "See Submission",
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
                                      AddScore(title);
                                      //Navigator.push(context,new MaterialPageRoute(builder: (context) => new ShowPdf(value: link)));
                                    },
                                    elevation: 10,
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const Text(
                                      "Assign Score",
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
