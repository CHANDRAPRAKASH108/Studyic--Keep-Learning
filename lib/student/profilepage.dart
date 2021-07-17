import 'dart:ffi';

import 'package:educationstudyic/allpayments/buycourses/othertransaction.dart';
import 'package:educationstudyic/allpayments/buycourses/transactionlist.dart';
import 'package:educationstudyic/widget/slidefromleft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../selectuser.dart';
import 'mypost.dart';

class ProfileStudent extends StatefulWidget {
  @override
  _ProfileStudentState createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent> {
  late Future<void> _launched;
  String _launchUrl = "https://zoom.us";
  String name='',college='',regd='',roll='',email='',url='';
  bool _isfetched = false;
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
  Future<void> _logout() async {
    final GoogleSignIn _gSignIn = GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await FirebaseAuth.instance.signOut();
    await _gSignIn.signOut();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new SelectUser(),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdetail();
  }

  @override
  _getdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      url = prefs.getString("simageurl")!;
      name = prefs.getString("sname")!;
      email = prefs.getString("semail")!;
      roll = prefs.getString("roll")!;
      regd = prefs.getString("regd_no")!;
      college = prefs.getString("college")!;
      _isfetched = true;
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
        body: _isfetched
            ? Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                decoration: const BoxDecoration(
                  //color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  children: [
                    Container(
                      child: (Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height:
                            MediaQuery.of(context).size.height * 0.02,
                          ),
                          Text(
                            'PROFILE',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height:
                            MediaQuery.of(context).size.height * 0.06,
                          ),
                          Container(
                            width:
                            MediaQuery.of(context).size.width * 0.85,
                            // height:
                            //     MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor,
                                  offset: Offset(10.0, 10.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                  MediaQuery.of(context).size.height *
                                      0.02,
                                ),
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(url),
                                  backgroundColor: Colors.blue,
                                ),
                                SizedBox(
                                  height:
                                  MediaQuery.of(context).size.height *
                                      0.04,
                                ),
                                Text(
                                  name.toUpperCase(),
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                SizedBox(
                                  height:
                                  MediaQuery.of(context).size.height *
                                      0.01,
                                ),
                                Text(email),
                              ],
                            ),
                          ),
                          SizedBox(
                            height:
                            MediaQuery.of(context).size.height * 0.04,
                          ),
                          ListTile(
                            leading: const Icon(Icons.home_work_outlined),
                            title: Text('College:- $college'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.app_registration),
                            title: Text('Registration:- $regd'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.how_to_reg),
                            title: Text('Roll Number:- $roll'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.post_add),
                            title: const Text('Your Posts'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideFromLeft(
                                      widget: ShowStudentUploaded(
                                          email: regd)));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.policy),
                            title: const Text('Privacy Policy'),
                            onTap: () {
                              _launchInBrowser(
                                  "https://github.com/studyic552/Studyic_privacy_policy/blob/main/studyicprivacypolicy.txt");
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.attach_money),
                            title: const Text('Course Transactions'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideFromLeft(
                                      widget:
                                      TransactionList(regd: regd)));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.attach_money),
                            title: const Text('Fee Transactions'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideFromLeft(
                                      widget:
                                      OtherTransaction()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('LogOut'),
                            onTap: () async {
                              _logout();
                            },
                          ),
                        ],
                      )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                        decoration:const BoxDecoration(color: Colors.white24),
                        child: const Text(
                          "Copyright©2021 Studyic",
                          textAlign: TextAlign.end,
                        ))
                  ],
                ),
              ),
            ),
          ),
        )
            : null);
  }
}

