import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Donate extends StatefulWidget {
  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  String name="name",regd="regd",email="email",roll="roll";
  late Razorpay _razorpay;
  int totalamount = 0;

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

  getdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      regd = prefs.getString("regd_no")!;
      name = prefs.getString("sname")!;
      email = prefs.getString("semail")!;
      roll = prefs.getString("roll")!;
    });
  }

  void openCheckOut() async {
    var options = {
      'key': 'rzp_live_33lMORlcACZuu2',
      'amount': totalamount * 100,
      'name': 'Studyic',
      'description': 'Fee Payment towards your organisation',
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

  DateTime dt = new DateTime.now();
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await FirebaseFirestore.instance
        .collection("Student")
        .doc(regd)
        .collection("Other Transactions")
        .doc()
        .set({
      'transaction_id': response.paymentId,
      'regd': regd,
      'status': 'success',
      'name': name,
      'email': email,
      'roll': roll,
      'amount': totalamount,
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
    Fluttertoast.showToast(
        msg:
        'Payment Successfull ..you can see transactions in your transaction history');
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    await FirebaseFirestore.instance
        .collection("Student")
        .doc(regd)
        .collection("Other Transactions")
        .doc()
        .set({
      'transaction_id': response.message,
      'regd': regd,
      'status': 'failed',
      'name': name,
      'email': email,
      'roll':roll,
      'amount': totalamount,
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
    Fluttertoast.showToast(
        msg:
        'Payment Failed ..you can see transactions in your transaction history');
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    Fluttertoast.showToast(msg: 'PAYMENT SUCCESSFUL');
    await FirebaseFirestore.instance
        .collection("Student")
        .doc(regd)
        .collection("Other Transactions")
        .doc()
        .set({
      'transaction_id': response.walletName,
      'regd': regd,
      'status': 'success',
      'name': name,
      'email': email,
      'roll':roll,
      'amount': totalamount,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fee Payment',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width / 30,
              ),
              LimitedBox(
                maxWidth: 90.0,
                child: Column(
                  children: [
                    Container(
                        height: 120.0,
                        child:
                        const Image(image: AssetImage("assets/images/logo.png"))),
                    SizedBox(height: MediaQuery.of(context).size.width / 10),
                    Container(
                      child: const Text(
                        'Studyic',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width / 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter Amount",
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            totalamount = num.parse(value).toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 20,
              ),
              RaisedButton(
                child: Text(
                  'Proceed For Payment',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  openCheckOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
