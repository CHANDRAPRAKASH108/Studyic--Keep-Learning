import 'package:educationstudyic/AdminandHod/visitclass.dart';
import 'package:educationstudyic/widget/textfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'getclass.dart';
String name='',email='',branch='',regd_no='';
class HomeHod extends StatefulWidget {
  String branch;
  HomeHod({required this.branch});
  @override
  _HomeHodState createState() => _HomeHodState(branch);
}

class _HomeHodState extends State<HomeHod> {
  String branch;
  _HomeHodState(this.branch);
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("HOD ($branch)"),
            backgroundColor: Colors.blue[900],
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person_outline_outlined),text: "Faculty",),
                Tab(icon: Icon(Icons.fact_check),text: "Student Details",)
              ],
            ),
          ),
          body: (TabBarView(children: [
            FetchTeachers(branch),
            FetchStudentDetail()
          ],)),
        ),
    );
  }
}

class FetchTeachers extends StatefulWidget {
  String branch;
  FetchTeachers(this.branch);
  @override
  _FetchTeachersState createState() => _FetchTeachersState(branch);
}

class _FetchTeachersState extends State<FetchTeachers> {
  String branch;
  _FetchTeachersState(this.branch);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Teacher")
            .where("branch", isEqualTo: branch)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: new CircularProgressIndicator());
          return Container(
            child: ListView(
              children: snapshot.data!.docs.map((document) {
                var value = document['name'];
                var email = document['email'];
                var branch = document['branch'];
                var id = document.id;
                return ListTile(
                  leading: Icon(Icons.person_outline_outlined),
                  title: Text(value),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Branch: $branch"),
                      Text("Email: $email")
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GetClass(id: id)));
                  },
                );
              }).toList(),
            ),
          );
        });
  }
}

bool _searched = false;
class FetchStudentDetail extends StatefulWidget {
  @override
  _FetchStudentDetailState createState() => _FetchStudentDetailState();
}

class _FetchStudentDetailState extends State<FetchStudentDetail> {
  getStudentDetail()async{
    await FirebaseFirestore.instance.collection("Student").doc(searchcontroller.text.toString().trim()).get()
        .then((DocumentSnapshot snapshot){
      if(snapshot.exists){
        setState(() {
          name = snapshot['name'];
          email = snapshot['email'];
          regd_no = snapshot['regd_no'];
          _searched = true;
        });
      }else{
        _searched = false;
      }
    });
  }
  TextEditingController searchcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                      child: TextFieldWidget("Search by registration number", searchcontroller, false)),
                  Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: ElevatedButton(onPressed: (){
                      getStudentDetail();
                    },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget> [
                          const Text('Search',style: TextStyle(color: Colors.white),),
                          SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                          const Icon(Icons.search,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                  Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.grey,
                              offset: Offset(10.0, 10.0),
                              blurRadius: 5.0,
                              spreadRadius: 5.0,
                            ),
                          ],
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: _searched ? ListTile(
                        leading: Icon(Icons.person_outline_outlined,size: 30.0,),
                        title: Text(name.toUpperCase(),style: TextStyle(fontSize: 18.0),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Registration Number:- $regd_no",style: TextStyle(fontSize: 16.0),),
                            Text("Email:- $email",style: TextStyle(fontSize: 16.0),),
                            SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              child: ElevatedButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VisitClass(regd: regd_no)));
                              }, child: const Text('Visit ClassRoom'),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                                ),
                              ),
                            )
                          ],
                        ),
                      ):const Text("")
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
