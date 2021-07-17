import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class GetSemester extends StatefulWidget {
  String fieldname,resulttype,yearname;
  GetSemester({required this.resulttype,required this.yearname,required this.fieldname});
  @override
  _GetSemesterState createState() => _GetSemesterState(resulttype,yearname,fieldname);
}

class _GetSemesterState extends State<GetSemester> {
  String fieldname,resulttype,yearname;
  _GetSemesterState(this.resulttype,this.yearname,this.fieldname);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Semester'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (SelectSemester(fieldname,resulttype,yearname)),
    );
  }
}

class SelectSemester extends StatelessWidget{
  String fieldname,resulttype,yearname;
  SelectSemester(this.fieldname,this.resulttype,this.yearname);
  late Future<void> _launched;

  //String _launchurl = "https://studyic.in";

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Result").doc(fieldname).collection(fieldname).doc(resulttype).collection(resulttype).doc(yearname).collection(yearname).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width/20),
            //margin: EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document){
                var semname = document.id;
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
                        height: MediaQuery.of(context).size.height*0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width/20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                      height: MediaQuery.of(context).size.height*0.2,
                                      child:  RaisedButton(onPressed:
                                          (){
                                            FirebaseFirestore.instance.collection("Result").doc(fieldname).collection(fieldname).doc(resulttype).collection(resulttype).doc(yearname).collection(yearname).doc(semname)
                                                .get()
                                                .then((DocumentSnapshot snapshot){
                                              if(snapshot.exists){
                                                var getlink= snapshot['Link'];
                                                _launchInBrowser(getlink);
                                                //Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewResult(Link: getlink,)));
                                              }
                                            });
                                      },
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Text(semname, style: const TextStyle(color: Colors.white),),
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
