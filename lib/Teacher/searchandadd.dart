import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

String searchitem='';
String name='',email='',regd='';
bool _searched = false;
class SearchAndAdd extends StatefulWidget {
  String firstdata,seconddata;
  SearchAndAdd({required this.firstdata,required this.seconddata});
  @override
  _SearchAndAddState createState() => _SearchAndAddState(firstdata,seconddata);
}

class _SearchAndAddState extends State<SearchAndAdd> {
  String firstdata,seconddata;
  _SearchAndAddState(this.firstdata,this.seconddata);
  @override
  Widget build(BuildContext context) {
    getStudentDetail()async{
      await FirebaseFirestore.instance.collection("Student").doc(searchitem).get()
          .then((DocumentSnapshot snapshot){
        if(snapshot.exists){
          setState(() {
            name = snapshot['name'];
            email = snapshot['email'];
            regd = searchitem;
            _searched = true;
          });
        }else{
          _searched = false;
        }
      });
    }
    TextEditingController search = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Students to class'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width/10),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                        hintText: "Enter Registration Number"
                    ),
                    controller: search,
                    onChanged: (text){
                      searchitem = search.text.toString();
                    },
                  ),
                  RaisedButton(onPressed: (){
                    getStudentDetail();
                  },
                      color: Colors.blue[900],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Search',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.035),),
                          const Icon(Icons.search,color: Colors.white,)
                        ],
                      )
                  ),
                  const SizedBox(height: 100.0,),
                  _searched ?Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Theme.of(context).primaryColor)
                      //border: BorderSide(color: Colors.blue[900])
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(name,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),),
                        Text(regd, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),),
                        RaisedButton(onPressed: ()async{
                          await FirebaseFirestore.instance
                              .collection(seconddata)
                              .doc(firstdata)
                              .collection(seconddata)
                              .doc(searchitem)
                              .set({
                            'TestData': "Data",
                          }).then((onValue) {
                            print('Created it in sub collection');
                          }).catchError((e) {
                            print('======Error======== ' + e);
                          });
                          await FirebaseFirestore.instance
                              .collection(searchitem)
                              .doc(firstdata)
                              .set({
                            'Attendance Counter': "0",
                            'Teacher Id': seconddata
                          }).then((onValue) {
                            print('Created it in sub collection');
                          }).catchError((e) {
                            print('======Error======== ' + e);
                          });
                          Fluttertoast.showToast(
                              msg: "Student Added Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.red,
                              backgroundColor: Colors.black
                          );
                        },
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: const Text('Add',style: TextStyle(color: Colors.white),),
                        )
                      ],
                    ),
                  ): const Center(child: Text('No Student Found'))
                ],
              ),
            )
        ),
      ),
    );
  }
}
