import 'dart:ffi';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class GetLive extends StatefulWidget {
  String classname,id;
  GetLive({required this.classname,required this.id});
  @override
  _GetLiveState createState() => _GetLiveState(classname,id);
}

class _GetLiveState extends State<GetLive> {
  String classname,id;
  _GetLiveState(this.classname,this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Classes'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (FetchLiveClass(classname,id)),
    );
  }
}

class FetchLiveClass extends StatefulWidget {
  String classname,id;
  FetchLiveClass(this.classname,this.id);
  @override
  _FetchLiveClassState createState() => _FetchLiveClassState(classname,id);
}

class _FetchLiveClassState extends State<FetchLiveClass> {
  String classname,id;
  _FetchLiveClassState(this.classname,this.id);

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},);
    } else {
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(id).doc(classname).collection("classes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0)
            ),
            child: ListView(
              children: snapshot.data!.docs.map((document){
                var value = document['Class_title'];
                var sub = document['Class_Subtitle'];
                var classlink = document['Class_link'];
                String startDate = document['date'];
                String startTime = document['time'];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(10.0, 10.0),
                          blurRadius: 5.0,
                          spreadRadius: 5.0,
                        )
                      ]
                  ),
                  child: ListTile(
                    tileColor: Colors.white,
                    leading: Icon(Icons.calendar_today),
                    title: Text(value),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(sub,style: TextStyle(fontSize: 18.0),),
                        Text("Date:- $startDate"),
                        Text("Time:- $startTime")
                      ],
                    ),
                    trailing: RaisedButton(onPressed: (){_launchInBrowser(classlink.toString());},child: Text('Join Now',style: TextStyle(color: Colors.white),),color: Colors.blue[900],),
                  ),
                );
              }).toList(),
            ),
          );
        }
    );
  }
}
