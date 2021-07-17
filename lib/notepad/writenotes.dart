import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class WriteNotes extends StatefulWidget {
  String email;
  WriteNotes({required this.email});
  @override
  _WriteNotesState createState() => _WriteNotesState(email);
}

class _WriteNotesState extends State<WriteNotes> {
  String email;
  String writtenone="your notes";
  _WriteNotesState(this.email);
  TextEditingController writing = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotePad'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: (){
            FirebaseFirestore.instance.collection("Notes").doc(email).collection("Notes").doc()
                .set({
              'content': writtenone
            });
          })
        ],
      ),
      body: (
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: 150,
                  child: SizedBox(
                    height: 100,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Write Here",
                      ),
                      controller: writing,
                      onChanged: (text){
                        writtenone = writing.text.toString();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
      ),
    );
  }
}
