import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
String studentname="studentname",studentroll="studentroll",studentregd="studentregd",studentdescription="studentdescription";
String mentorid="mentorid";
String roomnumber="roomnumber";
DateTime from = DateTime.now();
DateTime till = DateTime.now();
class StudentMentor extends StatefulWidget {
  String email;
  StudentMentor({required this.email});
  @override
  _StudentMentorState createState() => _StudentMentorState(email);
}

class _StudentMentorState extends State<StudentMentor> {
  String email;
  _StudentMentorState(this.email);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mentor Applications'),
          backgroundColor: Colors.blue[900],
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.note_add),text: "Leave Form",),
              Tab(icon: Icon(Icons.fact_check),text: "Submitted Applications",)
            ],
          ),
        ),
      body: (
      TabBarView(
        children: [
          Application(email: email),
          Submitted(email: email)
        ],
      )
      ),
    )
    );
  }
}

class Application extends StatefulWidget {
  String email;
  Application( {required this.email});
  @override
  _ApplicationState createState() => _ApplicationState(email);
}

class _ApplicationState extends State<Application> {
  String email,onselected='';
  _ApplicationState(this.email);
  @override
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController rollnumercontroller = new TextEditingController();
  TextEditingController registrationcontroller = new TextEditingController();
  TextEditingController descriptioncontroller = new TextEditingController();
  TextEditingController roomcontroller = new TextEditingController();
  TextEditingController hostelcontroller = new TextEditingController();

  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);

    SubmitApplication()async{
      progressDialog.show();
      progressDialog.update(message: "Submitting Application");
      await FirebaseFirestore.instance.collection("Mentee").doc(email).get()
          .then((DocumentSnapshot snapshot){
        if(snapshot.exists){
          mentorid = snapshot['Mentor Id'];
        }else{
          progressDialog.hide();
          Fluttertoast.showToast(
              msg: "You have no assinged mentor",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.red
          );
        }
      });
      if(studentname == null || studentregd ==null || studentroll==null || studentdescription ==null || from == null || till ==null || onselected == null || roomnumber ==null){
        progressDialog.hide();
        Fluttertoast.showToast(
            msg: "All the fields should be filled properly",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.red
        );
      }else{
        await FirebaseFirestore.instance.collection("Mentor").doc("Application").collection(mentorid).doc()
            .set({
          'name':studentname,
          'regd_number': studentregd,
          'roll_number':studentroll,
          'description':studentdescription,
          'email': email,
          'from':from.day.toString()+"/"+from.month.toString()+"/"+from.year.toString(),
          'till': till.day.toString()+"/"+till.month.toString()+"/"+till.year.toString(),
          'hostel': onselected,
          'room number': roomnumber,
          'status':"Submitted"
        }).then((onValue) {
          namecontroller.clear();
          rollnumercontroller.clear();
          registrationcontroller.clear();
          descriptioncontroller.clear();
          from=DateTime.now();
          till=DateTime.now();
          progressDialog.hide();
          Fluttertoast.showToast(
              msg: "Application submitted successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.red
          );
          print('Created it in sub collection');
        }).catchError((e) {
          print('======Error======== ' + e);
        });
        await FirebaseFirestore.instance.collection("Mentee").doc(email).collection("Applications").doc(email)
            .set({
          'name':studentname,
          'regd_number': studentregd,
          'roll_number':studentroll,
          'description':studentdescription,
          'from':from.day.toString()+"/"+from.month.toString()+"/"+from.year.toString(),
          'till': till.day.toString()+"/"+till.month.toString()+"/"+till.year.toString(),
          'roomnumber':roomnumber,
          'teacher status':"Submitted",
          'warden status': "Submitted",
          'hostel': onselected
        }).then((onValue) {
          namecontroller.clear();
          rollnumercontroller.clear();
          registrationcontroller.clear();
          descriptioncontroller.clear();
          roomcontroller.clear();
          hostelcontroller.clear();
          from=DateTime.now();
          till=DateTime.now();
          progressDialog.hide();
          Fluttertoast.showToast(
              msg: "Application submitted successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.red
          );
        }).catchError((e) {
        });
      }

    }
    return  SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20,right: MediaQuery.of(context).size.width/20,top: MediaQuery.of(context).size.width/10),
              child: Text('Leave Application',style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold,fontSize: 20.0,fontStyle: FontStyle.italic),),
            ),
            Container(
              padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10,top:MediaQuery.of(context).size.width/10),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Name",
                    labelText: "Name",
                    border: OutlineInputBorder()
                ),
                onChanged: (text){
                  studentname = namecontroller.text.toString();
                },
                controller: namecontroller,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10,top: MediaQuery.of(context).size.height/60),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Roll No.",
                    labelText: "Roll No.",
                    border: OutlineInputBorder()
                ),
                onChanged: (text){
                  studentroll = rollnumercontroller.text.toString();
                },
                controller: rollnumercontroller,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10,top: MediaQuery.of(context).size.height/40),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Regd No.",
                    labelText: "Regd No.",
                    border: OutlineInputBorder()
                ),
                onChanged: (text){
                  studentregd = registrationcontroller.text.toString();
                },
                controller: registrationcontroller,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10,top: MediaQuery.of(context).size.height/30),
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                    hintText: "Description for leave",
                    labelText: "Description for leave",
                    border: OutlineInputBorder()
                ),
                maxLength: 60,
                onChanged: (text){
                  studentdescription=descriptioncontroller.text.toString();
                },
                controller: descriptioncontroller,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10,top: MediaQuery.of(context).size.height/40),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Room No.",
                    labelText: "Room No.",
                    border: OutlineInputBorder()
                ),
                onChanged: (text){
                  roomnumber = roomcontroller.text.toString();
                },
                controller: roomcontroller,
              ),
            ),
            const SizedBox(height: 15.0,),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10,top: MediaQuery.of(context).size.height/40),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Hostel Name.",
                    labelText: "Hostel Name",
                    border: OutlineInputBorder()
                ),
                onChanged: (text){
                  onselected = hostelcontroller.text.toString();
                },
                controller: hostelcontroller,
              ),
            ),
            const SizedBox(height: 15.0,),
            Container(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10,top: MediaQuery.of(context).size.height/25),
                child: Text('Leave From',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]),)
            ),
            const SizedBox(height: 15.0,),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 50,
                    width: 300,
                    child: CupertinoDatePicker(
                      onDateTimeChanged: (datetime){
                        from = datetime;
                      },
                      initialDateTime: from,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              child: Text('Leave Till',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]),),
            ),
            const SizedBox(height: 15.0,),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 50,
                    width: 300,
                    child: CupertinoDatePicker(
                      onDateTimeChanged: (datetime){
                        till = datetime;
                      },
                      initialDateTime: till,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20,right: MediaQuery.of(context).size.width/20),
              width: MediaQuery.of(context).size.width*0.8,
              child: RaisedButton(
                onPressed: (){
                  SubmitApplication();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
                color: Colors.blue[900],
                child: Text('Submit Application',style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Submitted extends StatefulWidget {
  String email;
  Submitted({required this.email});
  @override
  _SubmittedState createState() => _SubmittedState(email);
}

class _SubmittedState extends State<Submitted> {
  String email;
  _SubmittedState(this.email);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Mentee").doc(email).collection("Applications").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            //padding: EdgeInsets.all(15.0),
            //margin: EdgeInsets.only(bottom: 15.0),
            child:  ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document){
                String name = document['name'];
                String regd_no = document['regd_number'];
                String roll_no = document['roll_number'];
                String till = document['till'];
                String from = document['from'];
                String description = document['description'];
                String teacherstatus = document['teacher status'];
                String wardenstatus = document['warden status'];
                String roomnumber = document['roomnumber'];
                String hostel = document['hostel'];
                return SingleChildScrollView(
                  child:  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(width: 2,color: Colors.lightBlueAccent)
                      ),
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                        },
                        child: Container(
                          //height: MediaQuery.of(context).size.height*0.4,
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountIssue()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.2),
                                                child: Icon(Icons.person_outline_outlined,size: 25.0,color: Colors.blue[900],)),
                                            Text(name,style: TextStyle(fontSize: 16.0,color: Colors.blue[900],fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.6),
                                                child: Icon(Icons.format_list_numbered_outlined,size: 25.0,color: Colors.blue[900],)),
                                            Container(
                                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                                child: Text(regd_no,style: TextStyle(fontSize: 15.0,color: Colors.blue[900]),)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0,),
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                                child: Icon(Icons.format_list_numbered_outlined,size: 25.0,color: Colors.blue[900],)),
                                            Container(
                                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                                child: Text(roll_no,style: TextStyle(fontSize: 15.0,color: Colors.blue[900]),)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width*0.9,
                                      decoration: BoxDecoration(
                                        //border: Border.all(color: Colors.blue[900]),
                                          borderRadius: BorderRadius.circular(15.0)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                              child: Text('Warden Status:- ',style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)
                                          ),
                                          Container(
                                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                              child: Text(wardenstatus,style: TextStyle(fontSize: 15.0,color: Colors.blue[900]),)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0,),
                                GestureDetector(
                                  onTap: ()async{
                                    /*Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new JustLogin(),
                                        ));*/
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width*0.9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                            child: Text('Mentor Status:- ',style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                            child: Center(child: Text(teacherstatus,style: TextStyle(color: Colors.blue[900],fontSize: 15.0),))),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5.0,),
                                GestureDetector(
                                  onTap: ()async{
                                    /*Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new JustLogin(),
                                        ));*/
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width*0.9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                            child: Text('From:- $from ',style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                            child: Center(child: Text("Till:- $till",style: TextStyle(color: Colors.blue[900],fontSize: 15.0),))),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: ()async{
                                    /*Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new JustLogin(),
                                        ));*/
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width*0.9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                            child: Center(child: SizedBox(
                                                width: MediaQuery.of(context).size.width*0.8,
                                                child: Text("Description:- $description",style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)))),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.0,),
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                                child: Text('Room Number:- $roomnumber',style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                                child: Text('Hostel Name:- $hostel',style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                teacherstatus=="Approved" && wardenstatus=="Approved"?Container(
                                  child: const Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage("https://i.pinimg.com/originals/06/ae/07/06ae072fb343a704ee80c2c55d2da80a.gif"),
                                  ),
                                ):teacherstatus == "Submitted" && wardenstatus=="Submitted"?Container(
                                  height: 50,
                                  width: 50,
                                  child: const Image(
                                    image: NetworkImage("https://media2.giphy.com/media/U7CnQe5OZ1xAdvxhSC/giphy.gif"),
                                  ),
                                ):Container(
                                  child: const Text("REJECTED",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: Colors.red),)
                                )
                              ]
                          ),
                        ),
                      )
                  ),
                );
              }).toList(),
            ),
          );
        }
    );
  }
}
