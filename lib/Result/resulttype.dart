import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:educationstudyic/Result/selectyear.dart';
class ResultType extends StatefulWidget {
  String fieldname;
  ResultType({required this.fieldname});
  @override
  _ResultTypeState createState() => _ResultTypeState(fieldname);
}

class _ResultTypeState extends State<ResultType> {
  String fieldname;
  _ResultTypeState(this.fieldname);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose One'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowResultType(fieldname)),
    );
  }
}

class ShowResultType extends StatelessWidget{
  String fieldname;
  ShowResultType(this.fieldname);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Result").doc(fieldname).collection(fieldname).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document){
                //var link = document['Uploaded link'];
                var resultype = document.id;
                return  Card(
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
                        height: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                //margin: EdgeInsets.only(top: 35, left: 30),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: EdgeInsets.only(left: 10),
                                      child: RaisedButton(onPressed:
                                          (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => SelectYear(resulttype: resultype,fieldname: fieldname)));
                                      },
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Text(resultype, style: const TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    )
                );
              }).toList(),
            ),
          );
        }
    );
  }
}