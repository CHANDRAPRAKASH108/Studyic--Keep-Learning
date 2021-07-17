import 'package:educationstudyic/selectuser.dart';
import 'package:educationstudyic/student/bottomscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:intl/intl.dart';
import 'Teacher/viewclasses.dart';
var tename,value,sname,semail,simageurl,usertype,regd;
Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  tename = prefs.getString("name");
  value = prefs.getString("teachervalue");
  sname = prefs.getString("sname");
  semail = prefs.getString("semail");
  simageurl = prefs.getString("simageurl");
  usertype = prefs.getString("userType");
  regd = prefs.getString("regd_no");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Colors.blue[900],
        brightness: Brightness.light,
        indicatorColor: Colors.blue[900],
        canvasColor: Colors.white,
        primaryColorDark: Colors.blue[900]
    ),
    // darkTheme: ThemeData(
    //     primaryColor: Colors.black,
    //     primaryColorBrightness: Brightness.dark,
    //     primaryColorLight: Colors.black,
    //     brightness: Brightness.dark,
    //     primaryColorDark: Colors.white,
    //     indicatorColor: Colors.white,
    //     canvasColor: Colors.black,
    //     appBarTheme: AppBarTheme(brightness: Brightness.dark)),
    home: MyApp(),
  )
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() =>  _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String currentday='';
  DateTime initial= DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial = DateTime.now();
    currentday = DateFormat('EEEE').format(initial);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SplashScreen(
          seconds: 5,
          navigateAfterSeconds: usertype == null ? SelectUser() :( usertype == 'student' ?  HomeStudent() : ViewClasses(value: value,name: tename,classday: currentday,)),
          title: const Text('Studyic',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white
            ),),
          image: Image.asset("assets/images/book.gif"),
          backgroundColor: Theme.of(context).primaryColor,
          styleTextUnderTheLoader: const TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.white
      ),
    );
  }
}

