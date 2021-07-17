import 'package:educationstudyic/widget/socialcard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

String id='';
class ShowStudentUploaded extends StatefulWidget {
  String email;
  ShowStudentUploaded({required this.email});
  @override
  _ShowStudentUploadedState createState() => _ShowStudentUploadedState(email);
}

class _ShowStudentUploadedState extends State<ShowStudentUploaded> {
  String email;
  _ShowStudentUploadedState(this.email);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Uploaded Content'),
        centerTitle: true,
      ),
      body: (
          ShowFetched(email)
      ),
    );
  }
}

class ShowFetched extends StatefulWidget {
  String email;
  ShowFetched(this.email);
  @override
  _ShowFetchedState createState() => _ShowFetchedState(email);
}

class _ShowFetchedState extends State<ShowFetched> {
  String email;
  _ShowFetchedState(this.email);
  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    DeleteClass(String email, String linkimg,String docsid,String random){
      return showDialog(context: context,builder: (context){
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Are you sure you want to delete the post ?',style: TextStyle(color: Colors.red),),
            content: Column(
                children: <Widget>[

                ]),
            actions: <Widget>[
              RaisedButton(onPressed: ()async{
                progressDialog.show();
                progressDialog.update(message: "Deleting Post....");
                FirebaseFirestore.instance.collection("Posts").doc(random)
                    .delete()
                    .then((onvalue){
                  print('Success');
                });
                FirebaseFirestore.instance.collection("Profilestudyic").doc("Profilestudyic").collection(email).doc(random)
                    .delete()
                    .then((onvalue){
                  print('Success profile');
                  Navigator.of(context).pop();
                  progressDialog.hide();
                });
              },
                child: Text('Delete Post'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
                color: Colors.blue[900],
              ),
              RaisedButton(onPressed: (){
                Navigator.of(context).pop();
              },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
                color: Colors.blue[900],
                child: Text('Cancel'),
              )
            ],
          ),
        );
      });
    }
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Profilestudyic").doc("Profilestudyic").collection(email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: ListView(
              children: snapshot.data!.docs.map((document){
                final String caption = document['caption'];
                String linkimg = document['image_url'];
                String nameis = document['name'];
                String docsid = document.id;
                String upload = document['uploaded'];
                String random = document['randomName'];
                bool is_image = document['is_image'];

                return GestureDetector(
                    onLongPress: ()async{
                      DeleteClass(email, linkimg,docsid,random);
                    },
                    child: SocialCard(uploader: upload,name: nameis,captions: caption,linkimage: linkimg,is_images: is_image,)
                );
              }).toList(),
            ),
          );
        }
    );
  }
}
