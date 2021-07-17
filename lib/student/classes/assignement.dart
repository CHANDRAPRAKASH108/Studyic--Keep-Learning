import 'package:educationstudyic/Teacher/showpdf.dart';
import 'package:educationstudyic/padllete/student.dart';
import 'package:educationstudyic/student/classes/post.dart';
import 'package:educationstudyic/student/classes/uploadassignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'attendance.dart';
import 'myclasses.dart';
import 'package:progress_dialog/progress_dialog.dart';

String subjectName="subname";
DateTime myDateTime= DateTime.now();
Timestamp timeStamp = DateTime.now().millisecondsSinceEpoch as Timestamp;
String uploadurl="uploadurl", score="score";
String url="url";
String mailId="mailid";
List<String> selectedfile=[];
var _object;
var uploadPdfUrl;
//ProgressDialog pd = ProgressDialog();

String assignmentTitle="assignment title";
String link="link";

bool _assignmentupload = false;

class Assignment extends StatefulWidget {
  final String subName;
  final String userEmailId,teacherid;
  const Assignment({required this.subName, required this.userEmailId,required this.teacherid});

  @override
  _AssignmentState createState() => _AssignmentState(subName, userEmailId,teacherid);
}

class _AssignmentState extends State<Assignment> {
  String subName;
  String userEmailId,teacherid;
  _AssignmentState(this.subName, this.userEmailId,this.teacherid);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    setState(() {
      subjectName = subName.toString();
      mailId = userEmailId.toString();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: (ShowAssignment(subName, mailId,teacherid)),
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ScheduledClass(subname: subName,mailId: mailId,teacherid: teacherid)));
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.person),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Attendance',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Attendance(subName: subName,mailId: mailId,teacherid: teacherid)));
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.assignment),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Post',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Posts(mailId: mailId,subName: subName,teacherid: teacherid)));
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.question_answer),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Vote',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StudentPadellete(mailId: mailId,subName: subName,teacherid: teacherid)));
            },
          ),
          //  Your other SpeeDialChildren go here.
        ],
      ),
    );
  }
}

class ShowAssignment extends StatefulWidget {
  String subName;
  String mailId,teacherid;
  ShowAssignment(this.subName, this.mailId,this.teacherid);
  @override
  _ShowAssignmentState createState() => _ShowAssignmentState(subName,mailId,teacherid);
}

class _ShowAssignmentState extends State<ShowAssignment> {
  String subName,mailId,teacherid;
  _ShowAssignmentState(this.subName,this.mailId,this.teacherid);
  bool isAllowedDeadline() {
    myDateTime = timeStamp.toDate();
    DateTime now = DateTime.now();
    if (now.isBefore(myDateTime)) {
      return true;
    } else {
      return false;
    }
  }
  getlink(String mailId, String subName, String value)async{
    await FirebaseFirestore.instance.collection(mailId).doc(subName).collection('upload').doc(value).get()
        .then((DocumentSnapshot snapshot){
      if(snapshot.exists){
        setState(() {
          url = snapshot['Uploaded link'];
        });
       Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowPdf(value: url)));
      }else{
        Fluttertoast.showToast(
            msg: "No Submission Found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            backgroundColor: Colors.black);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(teacherid)
            .doc(subName)
            .collection("Assignment")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document) {
                var value = document['Assignment_title'];
                var sub = document['''Assignment_Subtitle'''];
                String AssignmentLink = document['Assignment_Link'];
                String deadline = document['Assignment_Deadline'];
                timeStamp = document['Timestamp'];
                String deadlineTime = document['Assignment_Time'];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      //border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 5.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Container(
                    //padding: EdgeInsets.only(left: 10),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Text("Topic :",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width*0.04
                                )),
                            Text(
                              value.toString(),
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Sub-Title :",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: MediaQuery.of(context).size.width*0.04
                              ),
                            ),
                            Text(
                              sub.toString(),
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width*0.04
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text("Submission Deadline:",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width*0.04
                                )),
                            Text(deadline + " " + deadlineTime,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width*0.04
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //new Text(classlink, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            //margin: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ShowPdf(
                                          value: AssignmentLink
                                        ),
                                      ),
                                    );
                                  },
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.blue[900],
                                  child: Text(
                                    "See Assignment",
                                    style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/20,),
                                isAllowedDeadline()
                                    ? RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      assignmentTitle = value;
                                    });
                                    //AssignmentDialog(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadAssignmentStudent(deadlineTime: deadlineTime,deadline: deadline,value: value,subjectName: subjectName,userEmailId: mailId)));
                                  },
                                  elevation: 10,
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),
                                  ),
                                )
                                    : RaisedButton(onPressed: (){},
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  color: Colors.grey,
                                  child: const Text('Submit',style: TextStyle(color: Colors.white),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: ()async{
                            getlink(mailId,subName,value);
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowSubmission(mailId: mailId,subName: subName,assignmentTitle: value)));
                          },
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Theme.of(context).primaryColor)
                          ),
                          color: Colors.white,
                          child: Text(
                            "View Submission",
                            style: TextStyle(color: Colors.blue[900],fontSize: MediaQuery.of(context).size.width*0.04),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          );
        });
  }
}
