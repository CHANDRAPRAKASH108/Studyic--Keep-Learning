import 'package:educationstudyic/student/studentsocialmedia.dart';
import 'package:educationstudyic/widget/socialcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
bool _isliked = false;
var color = Colors.red;
String name="name",email="email",imageurl="imageurl";
class ShowStudentPost extends StatefulWidget {
  @override
  _ShowStudentPostState createState() => _ShowStudentPostState();
}

class _ShowStudentPostState extends State<ShowStudentPost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
  }
  @override
  _getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("sname")!;
      imageurl = prefs.getString("simageurl")!;
      email = prefs.getString("regd_no")!;
    });
  }
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(
                Icons.add_box,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SocialMedia(name: name,email: email,imageurl: imageurl)));
              },
            ),
          )
        ],
      ),
      body: (GetPost()),
    );
  }
}

class GetPost extends StatefulWidget {
  @override
  _GetPostState createState() => _GetPostState();
}

class _GetPostState extends State<GetPost> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Posts").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document){
                final String caption = document['caption'];
                String linkimg = document['image_url'];
                String nameis = document['name'];
                String numberoflike= document['likenumber'];
                String docsid = document.id;
                bool isliked = false;
                bool is_image = document['is_image'];
                String uploaded = document['uploaded'];
                return SocialCard(uploader: uploaded,name: nameis,captions: caption,linkimage: linkimg,is_images: is_image);
              }).toList(),
            ),
          );
        }
    );
  }
}