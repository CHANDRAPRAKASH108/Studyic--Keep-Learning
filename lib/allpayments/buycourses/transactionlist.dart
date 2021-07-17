import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String regd="regd";

class TransactionList extends StatefulWidget {
  String regd;
  TransactionList({required this.regd});
  @override
  _TransactionListState createState() => _TransactionListState(regd);
}

class _TransactionListState extends State<TransactionList> {
  String regd;
  _TransactionListState(this.regd);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Transactions'),
        centerTitle: true,
      ),
      body: (FetchTransactions(regd)),
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
            .collection("Transactions")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return new Center(child: CircularProgressIndicator());
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  //var coursename = document['coursename'];
                  var transaction_id = document['transaction_id'];
                  String status = document['status'];
                  var regd = document['regd'];
                  var course_name = document['course_name'];
                  var course_id = document['course_id'];
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          "Course Name:- " + course_name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 30.0),
                            Text("Registration Number:-" + regd,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            SizedBox(height: 30.0),
                            Text(
                              "Course Id:-" + course_id,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              children: <Widget>[
                                Text(
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
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}
