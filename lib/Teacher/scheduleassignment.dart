import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
var title;
var deadlinedate;
var subtitle;
var storeddate;
var status = "file not selected";
var _object;
String first='',second='';
DateTime initial = DateTime.now();
var pd;
bool _isselected = false;
class ScheduleAssignment extends StatefulWidget {
  String firstdata,seconddata;
  ScheduleAssignment({required this.firstdata,required this.seconddata});
  @override
  _ScheduleAssignmentState createState() => _ScheduleAssignmentState(firstdata,seconddata);
}

class _ScheduleAssignmentState extends State<ScheduleAssignment> {
  String firstdata,seconddata;
  _ScheduleAssignmentState(this.firstdata,this.seconddata);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      first =firstdata;
      second = seconddata;
    });
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController titlecontroller = new TextEditingController();
    TextEditingController subtitlecontroller = new TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Schedule Assignment'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: ShowForm(titlecontroller,subtitlecontroller,firstdata,seconddata)
    );
  }
}

class ShowForm extends StatefulWidget {
  TextEditingController titlecontroller,subtitlecontroller;
  String firstdata,seconddata;
  ShowForm(this.titlecontroller,this.subtitlecontroller,this.firstdata,this.seconddata);
  @override
  _ShowFormState createState() => _ShowFormState(titlecontroller,subtitlecontroller,firstdata,seconddata);
}

class _ShowFormState extends State<ShowForm> {
  TextEditingController titlecontroller,subtitlecontroller;
  String firstdata,seconddata;
  _ShowFormState(this.titlecontroller,this.subtitlecontroller,this.firstdata,this.seconddata);
  @override
  Finalallow(){
    pd = ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false);
    pd.show();
    pd.update(message: "Uploading Assignment");
    var rng  = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }

    if(_object != null) {
      setState(() {
        status = _object.paths.toString();
      });
      File file = File(_object.files.single.path);
      String fileName = '${randomName}.pdf';
      titlecontroller.clear();
      subtitlecontroller.clear();
      setState(() {
        _isselected = false;
      });
      savePdf(file, fileName);
    } else {
      // User canceled the picker
    }
  }
  var showfilename;
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: TextField
                      (
                      decoration: InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )
                      ),
                      onChanged: (text)
                      {
                        title=titlecontroller.text.toString();
                      },
                      controller: titlecontroller,
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: TextField
                      (
                      decoration: InputDecoration(
                          labelText: "Subtitle",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )
                      ),
                      onChanged: (text)
                      {
                        subtitle=subtitlecontroller.text.toString();
                      },
                      controller: subtitlecontroller,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    'Select Deadline',style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0,),
                  Column(
                    children: [
                      SizedBox(height: 80,
                        width: 300,
                        child: CupertinoDatePicker(
                          onDateTimeChanged: (datetime){
                            initial = datetime;
                          },
                          initialDateTime: initial,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: RaisedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf']);
                        setState(() {
                          _object = result;
                          _isselected = true;
                          showfilename = result!.paths.toString();
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: _isselected ? Colors.green: Colors.blue[900],
                      child: Text(_isselected ? "File Selected":"Select File", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  _isselected ? Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Text("$showfilename+",style: TextStyle(color: Colors.blue[900],fontSize: MediaQuery.of(context).size.width*0.03),)): const Text(''),
                  SizedBox(height: 20,),
                  _isselected ? Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: RaisedButton(onPressed: (){
                      if(title!=null){
                        if(subtitle!=null)
                        {
                          Finalallow();
                        }else{
                          Fluttertoast.showToast(
                              msg: "Subtitle is mandatory..",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.red
                          );
                        }
                      }else{
                        Fluttertoast.showToast(
                            msg: "Title is mandatory..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.red
                        );
                      }
                    },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Colors.blue[900],
                      child: Text('Upload Assignment',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),),
                    ),
                  ): const Text("")
                ],
              ),
            ),
          )
      ),
    );
  }
}

void savePdf(File file, String filename)async {
  Reference reference =FirebaseStorage.instance.ref().child(filename);
  UploadTask uploadTask =reference.putFile(file);
  String url = await(await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
  if(url!=null){
    documentFileUpload(url);
  }else{
    Fluttertoast.showToast(
        msg: "Pdf upload Unsuccessfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.green,
        backgroundColor: Colors.grey
    );
    pd.hide();
  }
}

void documentFileUpload(String url) {
  Timestamp myTimeStamp = Timestamp.fromDate(
      initial);
  DocumentReference documentReference = FirebaseFirestore.instance.collection(second).doc(first).collection("Assignment").doc();
  documentReference.set({
    'Assignment_title': title,
    'Assignment_Subtitle': subtitle,
    'Assignment_Link': url,
    'Assignment_Deadline': initial.day.toString() + "-" +
        initial.month.toString() + "-" +
        initial.year.toString(),
    'Assignment_Time': initial.hour.toString()+":"+initial.minute.toString(),
    'Timestamp': myTimeStamp
  });
  //lastupdated(second, first);
  Fluttertoast.showToast(
      msg: "Assignment Submitted successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: Colors.black
  );
  pd.hide();
}
