import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educationstudyic/notepad/writenotes.dart';

class ShowNotes extends StatefulWidget {
  String email;
  ShowNotes({required this.email});
  @override
  _ShowNotesState createState() => _ShowNotesState(email);
}

class _ShowNotesState extends State<ShowNotes> {
  String email;
  _ShowNotesState(this.email);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> WriteNotes(email: email)));
          })
        ],
      ),
      body: (FetchNotes(email)),
    );
  }
}

class FetchNotes extends StatelessWidget {
  String email;
  FetchNotes(this.email);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Notes").doc(email).collection("Notes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            child: ListView(
              children: snapshot.data!.docs.map((document){
                String content = document['content'];
                String id = document.id;
                return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        //side: BorderSide(width: 1,color: Colors.lightBlueAccent)
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                      },
                      child: GestureDetector(
                        onTap: (){
                        },
                        child: Container(
                          child: Row(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      IconButton(icon: const Icon(Icons.delete), onPressed: (){
                                        FirebaseFirestore.instance.collection("Notes").doc(email).collection("Notes").doc(id)
                                            .delete();
                                      }),
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width*0.9,
                                          child: Text(content,style: TextStyle(fontSize: 18.0),))
                                    ],
                                  ),
                                ),
                              ]
                          ),
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

