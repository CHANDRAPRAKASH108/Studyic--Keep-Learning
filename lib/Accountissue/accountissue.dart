import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountIssue extends StatefulWidget {
  @override
  _AccountIssueState createState() => _AccountIssueState();
}

class _AccountIssueState extends State<AccountIssue> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Help Center'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: (
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ExpansionTile(
                    leading:const  Icon(Icons.info_outline),
                    title: const Text("Account Issue",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                    children: <Widget>[
                      ExpansionTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("How to create class ?",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                        children: <Widget>[
                          SizedBox(width: MediaQuery.of(context).size.width*0.9,
                            child: const Text('When a teacher will login they will get a navigation bar on the upper left side, first click on that then there will be a option named as your routine click on that and click on the day on which you want to create class and fill up all the details and then click submit then click on view classes you can see all the classes for that day on the page',style: TextStyle(fontSize: 16.0),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const ExpansionTile(
                    leading: Icon(Icons.info_outline),
                    title: Text("Teacher.Class Issue",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                    children: <Widget>[
                      ExpansionTile(
                        leading: Icon(Icons.info_outline),
                        title: Text("What is Live class ?",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                        children: <Widget>[
                          Text('Live online classes are synchronous events organized in a live virtual meeting room where students and teachers meet together to communicate with voice, video, whiteboard. ... During such live classes the students can meet their instructor live over the internet to discuss different topics or problems',style: TextStyle(fontSize: 16.0),)
                        ],
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text("What is class routine page is for ?",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.9,
                        child:const Text("In this page you are getting all the classes on the basis of the day ..if today is monday then there is all the classes for monday",style: TextStyle(fontSize: 16.0),),
                      )
                    ],
                  ),
                  ExpansionTile(
                    leading:const  Icon(Icons.info_outline),
                    title: const Text("How can I delete my post from  studyic media ?",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Text('If you are a student go to the profile section by clickin on your image and there you will find studyic profile click on that and long press on the post then you will get option to delete the post or if you are a teacher you just need to tap on navigation bar then you will get studyic media over there and get the post and long press on that to get the delete option',style: TextStyle(fontSize: 16.0),),
                      )
                    ],
                  ),
                  SizedBox(height: 50.0,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.8,
                            child: Text('If you have any other issue please mail us on support@studyic.in , our team will get back to you soon',style: TextStyle(fontSize: 16.0,color: Colors.white,backgroundColor: Colors.blue[900]),)),
                      ),
                    ],
                  )
                ],
              ),
            )
        )
    );
  }
}
