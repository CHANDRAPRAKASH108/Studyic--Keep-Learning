import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
String regd="regd";
class PayNow extends StatefulWidget {
  String teachername, description, img, course, course_id;
  int price;
  PayNow(
      {required this.teachername,
      required this.price,
      required this.description,
      required this.img,
      required this.course,
      required this.course_id});
  @override
  _PayNowState createState() =>
      _PayNowState(teachername, price, description, img, course, course_id);
}

class _PayNowState extends State<PayNow> {
  String teachername="teachername", description="description", img="img", course="course", course_id="courseid";
  int price=0;
  _PayNowState(this.teachername, this.price, this.description, this.img,
      this.course, this.course_id);
  late Razorpay _razorpay;
  int totalamount = 0;
  DateTime dt = new DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetail();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckOut() async {
    var options = {
      'key': 'rzp_live_33lMORlcACZuu2',
      'amount': price * 100,
      'name': course,
      'description': 'This is to purchase your above mentioned course',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await FirebaseFirestore.instance
        .collection("Student")
        .doc(regd)
        .collection("Transactions")
        .doc()
        .set({
      'transaction_id': response.paymentId,
      'course_name': course,
      'course_id': course_id,
      'regd': regd,
      'status': 'success',
      'date': dt.day.toString() +
          "/" +
          dt.month.toString() +
          "/" +
          dt.year.toString(),
      'time': dt.hour.toString() +
          ":" +
          dt.minute.toString() +
          ":" +
          dt.second.toString()
    });
    await FirebaseFirestore.instance
        .collection("Student")
        .doc(regd)
        .collection("Courses")
        .doc()
        .set({
      'course_name': course,
      'course_id': course_id,
      'img': img,
      'teacher_name': teachername,
      'description': description
    });
    Fluttertoast.showToast(
        msg: 'Course Purchased Successfullly',
        textColor: Colors.white,
        backgroundColor: Colors.black);
  }

  void _handlePaymentError(PaymentFailureResponse response)async {
    Fluttertoast.showToast(msg: 'PAYMENT SUCCESS');
    await FirebaseFirestore.instance
        .collection("Student")
        .doc(regd)
        .collection("Transactions")
        .doc()
        .set({
      'transaction_id': response.message,
      'course_name': course,
      'course_id': course_id,
      'regd': regd,
      'status': 'success',
      'date': dt.day.toString() +
          "/" +
          dt.month.toString() +
          "/" +
          dt.year.toString(),
      'time': dt.hour.toString() +
          ":" +
          dt.minute.toString() +
          ":" +
          dt.second.toString()
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    Fluttertoast.showToast(msg: 'PAYMENT SUCCESS');
    await FirebaseFirestore.instance
        .collection("Student")
        .doc(regd)
        .collection("Transactions")
        .doc()
        .set({
      'transaction_id': response.walletName,
      'course_name': course,
      'course_id': course_id,
      'regd': regd,
      'status': 'success',
      'date': dt.day.toString() +
          "/" +
          dt.month.toString() +
          "/" +
          dt.year.toString(),
      'time': dt.hour.toString() +
          ":" +
          dt.minute.toString() +
          ":" +
          dt.second.toString()
    });
  }

  getdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      regd = prefs.getString("regd_no")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Purchase'),
        centerTitle: true,
      ),
      body: (Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 1.0,
              child: ListTile(
                title: Text(
                  course,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Text(
                      "Educator Name:-" + teachername,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue[900],
                      backgroundImage: NetworkImage(img),
                      radius: 70.0,
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "Description:-" + description,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    SizedBox(height: 15.0),
                    Text("Price:- ₹" + price.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    SizedBox(height: 15.0),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          onPressed: () {
                            openCheckOut();
                          },
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor)),
                        )),
                  ],
                ),
              ))
        ],
      )),
    );
  }
}
