import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

var link;
var classtitle;
var classsubtitle;
bool _isloading = false;
String dateis = '';
var timestampdate;
var timestamptime;
var timeis;
var pd;
bool _isrecording = false;

class EditClass extends StatefulWidget {
  var teacherid, subject, title, subtitle;
  EditClass({this.teacherid, this.subject, this.title, this.subtitle});
  @override
  _EditClassState createState() =>
      _EditClassState(teacherid, subject, title, subtitle);
}

class _EditClassState extends State<EditClass> {
  var teacherid, subject, title, subtitle;
  _EditClassState(this.teacherid,this.subject,this.title,this.subtitle);
  DateTime pickedDate = DateTime.now();
  TimeOfDay time =TimeOfDay.now();
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
        title: const Text('Update Detail'),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: (Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: "Rename Subtitle",
                      border: OutlineInputBorder()),
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
                  "Change Class Starting time",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Column(children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.8,
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
                          .collection(teacherid)
                          .doc(subject)
                          .collection("classes")
                          .doc(title)
                          .update({
                            'Class_Subtitle': classsubtitle,
                            'time': time.hour.toString() +
                                ":" +
                                time.minute.toString(),
                            'date': pickedDate.day.toString() +
                                "-" +
                                pickedDate.month.toString() +
                                "-" +
                                pickedDate.year.toString(),
                            'Timestamp': myTimeStamp
                          })
                          .then((onValue) {})
                          .catchError((e) {});
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
                      'Update Detail',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
