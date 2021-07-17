import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'getliveclass.dart';
class GetClass extends StatefulWidget {
  String id;
  GetClass({required this.id});
  @override
  _GetClassState createState() => _GetClassState(id);
}

class _GetClassState extends State<GetClass> {
  String id;
  _GetClassState(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (FetchClass(id)),
    );
  }
}

class FetchClass extends StatefulWidget {
  String id;
  FetchClass(this.id);
  @override
  _FetchClassState createState() => _FetchClassState(id);
}

class _FetchClassState extends State<FetchClass> {
  String id;
  _FetchClassState(this.id);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            child: ListView(
              children: snapshot.data!.docs.map((document){
                var classname = document.id;
                return ListTile(
                  leading: Image.asset("assets/images/logo.png"),
                  title: Text(classname),
                  trailing: const Icon(Icons.subject),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GetLive(classname:classname,id:id)));
                  },
                );
              }).toList(),
            ),
          );
        }
    );
  }
}
