
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:educationstudyic/mentor/menteelist.dart';
import 'package:educationstudyic/mentor/showapplications.dart';

String emailstudent="youremail";
String mentorname="mentorname",mentoremail="mentoremail",mentorphone="mentorphone";
class TeacherSideMentor extends StatefulWidget {
  String id;
  TeacherSideMentor({required this.id});
  @override
  _TeacherSideMentorState createState() => _TeacherSideMentorState(id);
}

class _TeacherSideMentorState extends State<TeacherSideMentor> {
  String id;
  _TeacherSideMentorState(this.id);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    ProgressDialog progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);

    CreateAlertDialog(BuildContext context){
      TextEditingController customcontroller = TextEditingController();
      TextEditingController uidcontroller = TextEditingController();
      return showDialog(context: context,builder: (context){
        return AlertDialog(
          title: Text('Enter Details'),
          content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Student Email',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text){
                    emailstudent = customcontroller.text.toString();
                  },
                  controller: customcontroller,
                )
              ]),
          actions: <Widget>[
            MaterialButton(
                elevation: 5.0,
                child: Text("Submit"),
                onPressed: () async {
                  progressDialog.show();
                  progressDialog.update(message: "Adding Student");
                  // DocumentReference messageRef = db .collection("rooms").document("roomA") .collection("messages").document("message1");
                  await FirebaseFirestore.instance
                      .collection("Mentor")
                      .doc("Mentee")
                      .collection(id)
                      .doc(emailstudent)
                      .set({
                    'TestData': "Data",
                  }).then((onValue) {
                    print('Created it in sub collection');
                  }).catchError((e) {
                    print('======Error======== ' + e);
                  });

                  await FirebaseFirestore.instance.collection("Teacher").doc(id).get()
                  .then((DocumentSnapshot snapshot){
                    mentorname = snapshot['name'];
                    mentoremail = snapshot['email'];
                    mentorphone = snapshot['phone'];
                  });
                  await FirebaseFirestore.instance
                      .collection("Mentee")
                      .doc(emailstudent)
                      .set({
                    'Mentor Name':mentorname,
                    'Mentor phone':mentorphone,
                    'Mentor Email':mentoremail,
                    'Mentor Id': id
                  }).then((onValue) {
                    print('Created it in sub collection');
                  }).catchError((e) {
                    print('======Error======== ' + e);
                  });
                  progressDialog.hide();
                  customcontroller.clear();
                }),
            MaterialButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (context)=> new MenteeList(id:id)));
                },
                child: Container(
                height: MediaQuery.of(context).size.width/3,
                  width: MediaQuery.of(context).size.width*1.0,
                  margin: EdgeInsets.only(top: 50.0,left: 30.0,right: 30.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(width: 2.0,color: Colors.white),
                    gradient:LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.purple,Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 35.0),
                      child: Column(
                        children: [
                          Icon(Icons.group_outlined,size: 45.0,color: Colors.white,),
                          Text('Mentee List',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 25.0,fontStyle: FontStyle.italic),),
                        ],
                      )),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (context)=> new ShowApplications(id:id)));
                },
                child: Container(
                  height: MediaQuery.of(context).size.width/3,
                  width: MediaQuery.of(context).size.width*1.0,
                  margin: EdgeInsets.only(top: 50.0,left: 30.0,right: 30.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 2.0,color: Colors.white),
                      gradient:LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.purple,Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Container(
                      margin: EdgeInsets.only(top: 35.0),
                      child: Column(
                        children: [
                          Icon(Icons.note_rounded,size: 45.0,color: Colors.white,),
                          Text('Leave Applications',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 25.0,fontStyle: FontStyle.italic),),
                        ],
                      )),
                ),
              ),

              GestureDetector(
                onTap: (){
                  CreateAlertDialog(context);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width/3,
                  width: MediaQuery.of(context).size.width*1.0,
                  margin: EdgeInsets.only(top: 50.0,left: 30.0,right: 30.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 2.0,color: Colors.white),
                      gradient:LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.purple,Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Container(
                      margin: EdgeInsets.only(top: 35.0),
                      child: Column(
                        children: [
                          Icon(Icons.person_add,size: 45.0,color: Colors.white,),
                          Text('Add Students',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 25.0,fontStyle: FontStyle.italic),),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


