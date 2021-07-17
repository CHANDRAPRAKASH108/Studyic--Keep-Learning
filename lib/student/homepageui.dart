import 'package:educationstudyic/Accountissue/accountissue.dart';
import 'package:educationstudyic/Result/mainpage.dart';
import 'package:educationstudyic/allpayments/buycourses/donate.dart';
import 'package:educationstudyic/allpayments/buycourses/studentuibuy.dart';
import 'package:educationstudyic/mentor/studentmentor.dart';
import 'package:educationstudyic/notepad/shownotes.dart';
import 'package:educationstudyic/student/studentshowpost.dart';
import 'package:educationstudyic/widget/scrollablecard.dart';
import 'package:educationstudyic/widget/tiel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../aboutuspage.dart';
import '../selectuser.dart';
import 'card.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:carousel_slider/carousel_slider.dart';
class HomePageUI extends StatefulWidget {
  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  String name="",url="",regd="";
  @override
  Widget build(BuildContext context) {
    @override
    final GoogleSignIn _gSignIn = GoogleSignIn();
    var _image;
    @override

    String greetingMessage() {
      var timeNow = DateTime.now().hour;

      if (timeNow <= 12) {
        _image = "assets/images/sun.png";
        return 'Good Morning';
      } else if ((timeNow > 12) && (timeNow <= 16)) {
        _image = "assets/images/sun.png";
        return 'Good Afternoon';
      } else if ((timeNow > 16) && (timeNow < 20)) {
        _image = "assets/images/moon.png";
        return 'Good Evening';
      } else {
        _image = "assets/images/moon.png";
        return 'Good Evening';
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Studyic',
          style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        color: Colors.blue[900],
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: Colors.blue[900],
                child: DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.blue[900],
                            backgroundImage: NetworkImage(url),
                          ),
                          const SizedBox(height:5.0),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(name,
                                  style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.04,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListTiel(
                  widget: ShowStudentPost(),
                  titletxt: 'SocialMedia',
                  icon: Icons.network_check_outlined),
              ListTiel(
                  widget: MainPage(),
                  titletxt: 'Results',
                  icon: Icons.assignment),
              ListTiel(
                  widget: ShowNotes(
                    email: regd,
                  ),
                  titletxt: 'Notepad',
                  icon: Icons.assignment),
              ListTiel(
                widget: AccountIssue(),
                titletxt: 'Account Issue',
                icon: Icons.person_outline_outlined,
              ),
              ListTiel(
                widget: ShowAbout(),
                titletxt: 'About Us',
                icon: Icons.description,
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text(
                  'LogOut',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await _gSignIn.signOut();
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectUser(),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          width: MediaQuery.of(context).size.width * 1.0,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(40.0),
                                bottomRight: Radius.circular(40.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.03,
                                      ),
                                      Text(
                                        greetingMessage(),
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.02,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.67,
                                          child: Text(
                                            name.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                MediaQuery.of(context).size.width * 0.04,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  Image(
                                    image: AssetImage(_image),
                                    height: MediaQuery.of(context).size.height * 0.08,
                                    width: MediaQuery.of(context).size.width * 0.1,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.045,
                              ),
                              Container(
                                  child: CarouselSlider(
                                    items: [
                                      ScrollableCard(
                                          'assets/images/summentor.png',
                                          StudentMentor(
                                            email: regd,
                                          )),
                                      ScrollableCard('assets/images/summedia.png',
                                          ShowStudentPost()),
                                      ScrollableCard(
                                          'assets/images/sumnote.png',
                                          ShowNotes(
                                            email: regd,
                                          )),
                                    ],
                                    options: CarouselOptions(
                                      height:
                                      MediaQuery.of(context).size.height * 0.26,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      aspectRatio: 16 / 9,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enableInfiniteScroll: true,
                                      autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                      viewportFraction: 0.8,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        StudentCard("assets/images/sumonline.png", BuyUi()),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        StudentCard(
                            "assets/images/summentor.png",
                            StudentMentor(
                              email: regd,
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        StudentCard("assets/images/sumpayment.png", Donate()),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("sname")!;
      url = prefs.getString("simageurl")!;
      regd = prefs.getString("regd_no")!;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

}
