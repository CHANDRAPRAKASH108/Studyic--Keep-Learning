import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String regd='';
class OtherTransaction extends StatefulWidget {
  @override
  _OtherTransactionState createState() => _OtherTransactionState();
}

class _OtherTransactionState extends State<OtherTransaction> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetail();
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
        title: const Text('Fee Transactions'),
        centerTitle: true,
      ),
      body: (regd.isEmpty ? const Center(child: CircularProgressIndicator(),):FetchTransactions(regd)),
    );
  }
}

class FetchTransactions extends StatefulWidget {
  String regd;
  FetchTransactions(this.regd);
  @override
  _FetchTransactionsState createState() => _FetchTransactionsState(regd);
}
class _FetchTransactionsState extends State<FetchTransactions> {
  String regd;
  _FetchTransactionsState(this.regd);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Student")
            .doc(regd)
            .collection("Other Transactions")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  var transaction_id = document['transaction_id'];
                  String status = document['status'];
                  var regd = document['regd'];
                  var course_name = document['roll'];
                  var course_id = document['amount'];
                  var date = document['date'];
                  var time = document['time'];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text(
                            "Roll Number:- " + course_name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 30.0),
                              Text("Registration Number:-" + regd,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: 30.0),
                              Text(
                                "Amount:- INR " + course_id.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 30.0),
                              Row(
                                children: <Widget>[
                                  const Text(
                                    'Transaction Id:-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    transaction_id,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.0),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Status:-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    status,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                'Date:-' + date,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                'Time:-' + time,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                              // Text(
                              //   'Status:-' + status,
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.green),
                              // ),
                            ],
                          ),
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