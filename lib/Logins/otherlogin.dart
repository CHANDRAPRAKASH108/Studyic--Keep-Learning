import 'package:educationstudyic/AdminandHod/adminhome.dart';
import 'package:educationstudyic/AdminandHod/homehod.dart';
import 'package:educationstudyic/Teacher/viewclasses.dart';
import 'package:educationstudyic/widget/normaltextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';
String email='', password='', value='', emailtext='';
String passtext='';
var name;
String _name='', _email='', _regdno='', college='';
DateTime initial= DateTime.now();
String currentday='', branch='', hodusername='', hodpassword='', fetchhod='';

class JustLogin extends StatefulWidget {
  @override
  _JustLoginState createState() => _JustLoginState();
}

class _JustLoginState extends State<JustLogin> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = new TextEditingController();
    TextEditingController passwordcontroller = new TextEditingController();
    TextEditingController usernamecntr = new TextEditingController();
    TextEditingController passwordcntr = new TextEditingController();

    gettoast(message) {
      return Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          textColor: Colors.white,
          backgroundColor: Colors.black);
    }
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    SignInHOD() async {
      progressDialog.show();
      progressDialog.update(message: "Authenticating User");
      final snapShot = await FirebaseFirestore.instance
          .collection('HOD')
          .doc(usernamecntr.text.toString().trim())
          .get();
      if (snapShot.exists) {
        final snap = await FirebaseFirestore.instance
            .collection("HOD")
            .doc(usernamecntr.text.toString().trim())
            .get();
        fetchhod = snap['password'];
        if (fetchhod == passwordcntr.text.toString().trim()) {
          value = snapShot.id;
          progressDialog.update(message: "Logging In");
          Map<String, dynamic>? data = snapShot.data();
          setState(() {
            branch = data!['branch'];
          });
          usernamecntr.clear();
          passwordcntr.clear();
          Navigator.of(context).pop();
          progressDialog.hide();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeHod(branch: branch)));
        } else {
          gettoast("Password dosen't match with user id");
          progressDialog.hide();
        }
      } else {
        progressDialog.hide();
        gettoast("Username dosen't match");
      }
    }

    SignInAdmin() async {
      progressDialog.show();
      progressDialog.update(message: "Authenticating User");
      final snapShot = await FirebaseFirestore.instance
          .collection('Admin')
          .doc(usernamecntr.text.toString())
          .get();
      if (snapShot.exists) {
        final snap = await FirebaseFirestore.instance
            .collection("Admin")
            .doc(usernamecntr.text.toString())
            .get();
        fetchhod = snap['password'];
        if (fetchhod == passwordcntr.text.toString()) {
          value = snapShot.id;
          progressDialog.update(message: "Logging In");
          Map<String, dynamic>? data = snapShot.data();
          setState(() {
            college = data!['college'];
          });
          usernamecntr.clear();
          passwordcntr.clear();
          Navigator.of(context).pop();
          progressDialog.hide();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminHome(college: college)));
        } else {
          gettoast("Password dosen't match with the user id");
          progressDialog.hide();
        }
      } else {
        progressDialog.hide();
        gettoast("Username not found");
      }
    }

    SignInTeacher() async {
      progressDialog.show();
      progressDialog.update(message: "Authenticating User");
      final snapShot = await FirebaseFirestore.instance
          .collection('Teacher')
          .doc(emailcontroller.text.toString())
          .get();
      if (snapShot.exists) {
        final snap = await FirebaseFirestore.instance
            .collection("Teacher")
            .doc(emailcontroller.text.toString())
            .get();
        passtext = snap['password'];
        if (passtext == passwordcontroller.text.toString()) {
          value = snapShot.id;
          progressDialog.update(message: "Logging In");
          Map<String, dynamic>? data = snapShot.data();
          setState(() {
            name = data!['name'];
          });
          progressDialog.hide();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(
            'teacheremail',
            email,
          );
          prefs.setString('teachervalue', value);
          prefs.setString('name', name);
          prefs.setString("userType", 'teacher');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewClasses(
                    value: value,
                    name: name,
                    classday: currentday,
                  )));
          //Navigator.push(context, MaterialPageRoute(builder: (context) => new TeacherHomeInside(value: value, name: name)));
        } else {
          gettoast("Password dosen't match with the user id");
          progressDialog.hide();
        }
      } else {
        progressDialog.hide();
        gettoast("Please enter correct user id");
      }
    }

    bottomdrag(String logintype, Function _func) {
      showModalBottomSheet<void>(
        backgroundColor: Colors.blue[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.0),
              topRight: Radius.circular(45.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        logintype,
                        style: const TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: NormalTextField(
                              'Enter Username', usernamecntr, false)),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: NormalTextField(
                              'Enter Password', passwordcntr, true)),
                      const SizedBox(
                        height: 20.0,
                      ),
                      // ignore: deprecated_member_use
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              onPressed: () {
                                if (usernamecntr.text.toString().isNotEmpty) {
                                  if (passwordcntr.text.toString().isNotEmpty) {
                                    _func();
                                  } else {
                                    Scaffold.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Pasword is Mandatory")));
                                  }
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Username is Mandatory")));
                                }
                              },
                              child: const Text('Login'))),
                      // BlueButton(
                      //     "Login", _func, emailcontroller, passwordcontroller),
                      const SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(body: Builder(
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor,
                            offset: const Offset(5.0, 5.0),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Image(
                        height: MediaQuery.of(context).size.height*0.2,
                        image: const AssetImage('assets/images/studyic.png'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        //style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Enter Username",
                          labelStyle: TextStyle(color: Colors.blue[900]),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        controller: emailcontroller,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        //style: TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Enter Password",
                          labelStyle: TextStyle(color: Colors.blue[900]),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        controller: passwordcontroller,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue[900],
                        onPressed: () {
                          if (emailcontroller.text.toString().isNotEmpty) {
                            if (passwordcontroller.text
                                .toString()
                                .isNotEmpty) {
                              SignInTeacher();
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: new Text("Pasword is Mandatory")));
                            }
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: new Text("Username is Mandatory")));
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pushReplacement(
                        //     context, SlideFromLeft(widget: ForgotPass()));
                      },
                      child: Container(
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Divider(
                          color: Colors.blue[900],
                        )),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => WardenLogin()));
                          },
                          child: Container(
                            child: const Text(
                              'I am warden ?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Container(
                          child: GestureDetector(
                              onTap: () {
                                bottomdrag("Admin Login", SignInAdmin);
                              },
                              child: const Text(
                                'I am Admin ?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              bottomdrag('Hod Login', SignInHOD);
                            },
                            child: const Text(
                              "I am HOD?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  ],
                )),
          ),
        );
      },
    ));
  }
}
