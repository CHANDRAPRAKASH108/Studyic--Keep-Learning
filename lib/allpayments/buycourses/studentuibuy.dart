import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:educationstudyic/widget/slidefromleft.dart';
import 'package:educationstudyic/allpayments/buycourses/getcourses.dart';
import 'package:educationstudyic/allpayments/buycourses/paynow.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BuyUi extends StatefulWidget {
  @override
  _BuyUiState createState() => _BuyUiState();
}

class _BuyUiState extends State<BuyUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find your courses here',
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.end,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        actions: <Widget>[
          Container(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GetCourses()));
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white)),
                  child: Text(
                    'Click Here',
                    style: TextStyle(color: Colors.blue[900]),
                  )))
        ],
      ),
      body: (ShowCourses()),
    );
  }
}

class ShowCourses extends StatefulWidget {
  late Razorpay _razorpay;
  int totalamount = 0;

  @override
  _ShowCoursesState createState() => _ShowCoursesState();
}

class _ShowCoursesState extends State<ShowCourses> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Courses").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  var coursename = document['coursename'];
                  var teachername = document['name'];
                  int price = document['price'];
                  var description = document['Description'];
                  var img = document['img'];
                  var course_id = document['course_id'];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                             BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          border: Border.all(color: Theme.of(context).primaryColor),
                          image: DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.2),
                                  BlendMode.dstATop),
                              image:
                                  AssetImage("assets/images/yourcourses.jpg"),
                              fit: BoxFit.cover)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[900],
                          backgroundImage: NetworkImage(img),
                          radius: 35.0,
                        ),
                        title: Text(coursename),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "By:-" + teachername,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text("Price:-INR " + price.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            Text(
                              "Description:-" + description,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const Text(
                              'Once you buy any course it will be avilabel for life time',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        SlideFromLeft(
                                            widget: PayNow(
                                          teachername: teachername,
                                          price: price,
                                          description: description,
                                          img: img,
                                          course: coursename,
                                          course_id: course_id,
                                        )));
                                  },
                                  child: const Text(
                                    'Buy Now',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Theme.of(context).primaryColor)),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}
