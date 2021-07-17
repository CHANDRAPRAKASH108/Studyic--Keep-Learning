import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:educationstudyic/Result/getsem.dart';
class SelectYear extends StatefulWidget {
  String resulttype;
  String fieldname;
  SelectYear({required this.resulttype,required this.fieldname});
  @override
  _SelectYearState createState() => _SelectYearState(resulttype,fieldname);
}

class _SelectYearState extends State<SelectYear> {
  String resulttype;
  String fieldname;
  _SelectYearState(this.resulttype,this.fieldname);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(title: Text('Select Year'),
      centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowYears(resulttype,fieldname)),
    );
  }
}

class ShowYears extends StatelessWidget {
  String resulttype,fieldname;
  ShowYears(this.resulttype,this.fieldname);

  @override
  Widget build(BuildContext context) {
    print("field name $fieldname    result type $resulttype");
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Result").doc(fieldname).collection(fieldname).doc(resulttype).collection(resulttype).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            //padding: EdgeInsets.all(15.0),
            //margin: EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document){
                //var link = document['Uploaded link'];
                var yearname = document.id;
                return Card(
                    shadowColor: Colors.blue[900],
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
                        //height: MediaQuery.of(context).size.height*0.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 35),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                      child: RaisedButton(onPressed:
                                          (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => GetSemester(fieldname: fieldname,resulttype: resulttype,yearname:yearname)));
                                      },
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Text(yearname, style: const TextStyle(color: Colors.white),),
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
