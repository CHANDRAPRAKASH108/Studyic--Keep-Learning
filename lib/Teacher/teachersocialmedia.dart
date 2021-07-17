import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
var pd;
var imagename;
var teachername;
bool _imagepicked = false;
var sharepoststr;

class TeacherSocialMedia extends StatefulWidget {
  String teacherid;
  TeacherSocialMedia({required this.teacherid});
  @override
  _TeacherSocialMediaState createState() => _TeacherSocialMediaState(teacherid);
}

class _TeacherSocialMediaState extends State<TeacherSocialMedia> {
  var  teacherid;
  _TeacherSocialMediaState(this.teacherid);

  var _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imagepicked = true;
      } else {
      }
    });
  }

  Future getCImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 25, maxHeight: 350, maxWidth: 350);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imagepicked = true;
        print("this is image path  $_image");
      } else {
        print('No image selected.');
      }
    });
  }
  TextEditingController captioncontroller = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getteachername();
  }

  getteachername(){
    FirebaseFirestore.instance.collection("Teacher").doc(teacherid).get()
        .then((DocumentSnapshot snapshot){
      if(snapshot.exists){
        teachername = snapshot['name'];
      }
    });
  }

  TextEditingController postcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context, type: ProgressDialogType.Normal);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Share Post'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 35.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: TextField(
                          maxLines: 10,
                          decoration: InputDecoration(
                            labelText: "Share Post",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color:Theme.of(context).primaryColor)
                            ),
                          ),
                          controller: postcontroller,
                          onChanged: (text){
                            sharepoststr = postcontroller.text.toString();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: FlatButton(onPressed: (){
                    share(teacherid);
                  },child: const Text('Post',style: TextStyle(color: Colors.white),),
                    color: Colors.blue[900],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: "Enter Caption"
                    ),
                    controller: captioncontroller,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        getImage();
                      },
                      child: InkWell(
                        onTap: getImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 60.0,
                          child: CircleAvatar(
                            radius: 60.0,
                            child: ClipOval(
                                child : Image.network("https://cdn1.iconfinder.com/data/icons/rounded-black-basic-ui/139/Gallery-RoundedBlack-512.png")
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    GestureDetector(
                      onTap: (){
                        getImage();
                      },
                      child: InkWell(
                        onTap: getCImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 60.0,
                          child: CircleAvatar(
                            radius: 60.0,
                            child: ClipOval(
                              child: Image.network("https://cdn1.iconfinder.com/data/icons/black-round-web-icons/100/round-web-icons-black-07-512.png"),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 18.0),
                  child: Text('Click on icon to select your photo', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                ),
                _imagepicked ? Container(
                  child: Image.file(_image),
                ): Text(""),
                SizedBox(height: 20.0,),
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  padding: EdgeInsets.only(top: 35),
                  child: RaisedButton(
                    onPressed: (){
                      sharepost(teacherid);
                    },
                    child: Text('Share Post',style: TextStyle(color: Colors.white),),
                    color: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  share(String teacherid)async{
    var rng  = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    pd.show();
    pd.update(message: "Share Post");
    if(sharepoststr!=null){
      await FirebaseFirestore.instance.collection("Posts").doc(randomName)
          .set({
        'image_url': sharepoststr,
        'caption': "",
        'name': teachername,
        'likenumber':"0",
        'randomName': randomName,
        'is_image': false,
        'uploaded':'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'
      });
      await FirebaseFirestore.instance.collection("Profilestudyic").doc("Profilestudyic").collection(teacherid).doc(randomName)
          .set({
        'image_url': sharepoststr,
        'caption': "",
        'name': teachername,
        'likenumber':"0",
        'randomName':randomName,
        'is_image': false,
        'uploaded':'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'
      });
      postcontroller.clear();
      Fluttertoast.showToast(
          msg: "Post uploaded successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          backgroundColor: Colors.white
      );
      pd.hide();
    }else{
      Fluttertoast.showToast(
          msg: "Please enter some text",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          backgroundColor: Colors.white
      );
      pd.hide();
    }
  }
  void sharepost(String teacherid) async{

    var rng  = Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    if(_image!=null){
      pd.show();
      pd.update(message: "Uploading Post..");

      final String caption = captioncontroller.text.toString();
      Reference ref = FirebaseStorage.instance.ref();
      TaskSnapshot addImg = await ref.child("image/$randomName").putFile(_image).whenComplete(() => null);


      if(addImg!=null){
        final String downloadUrl = await addImg.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection("Posts").doc(randomName)
            .set({
          'image_url': downloadUrl,
          'caption': caption,
          'name': teachername,
          'likenumber':"0",
          'randomName': randomName,
          'is_image': true,
          'uploaded':'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'
        });
        await FirebaseFirestore.instance.collection("Profilestudyic").doc("Profilestudyic").collection(teacherid).doc(randomName)
            .set({
          'image_url': downloadUrl,
          'caption': caption,
          'name': teachername,
          'likenumber':"0",
          'randomName':randomName,
          'is_image': true,
          'uploaded':'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'
        });
        captioncontroller.clear();

        Fluttertoast.showToast(
            msg: "Post uploaded successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.green,
            backgroundColor: Colors.white
        );
        pd.hide();
      }else{
        Fluttertoast.showToast(
            msg: "Post uploading failed please try again..",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.green,
            backgroundColor: Colors.white
        );
        pd.hide();
      }
    }else{
      Fluttertoast.showToast(
          msg: "Post uploading failed please try again..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          backgroundColor: Colors.white
      );
      pd.hide();
    }
  }

}
