import 'package:educationstudyic/padllete/student.dart';
import 'package:educationstudyic/student/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';
import 'assignement.dart';
import 'myclasses.dart';
int numClasses=0;
double present=0.0;
double totalClasses=0.0;
double absent=0.0;
double percentage=0.0;
//int productCount = 5;
Map<String, double> dataMap=[] as Map<String, double>;
bool _isloading = false;
class Attendance extends StatefulWidget {
  String subName;
  String mailId,teacherid;
  //double numClasses;
  Attendance({required this.subName, required this.mailId,required this.teacherid});
  @override
  _AttendanceState createState() => _AttendanceState(subName, mailId,teacherid);
}

class _AttendanceState extends State<Attendance> {
  String subName;
  String mailId,teacherid;
  _AttendanceState(this.subName, this.mailId,this.teacherid);

  @override
  void initState() {
    super.initState();
    FetchData();
  }

  FetchData()async{
    await FirebaseFirestore.instance
        .collection(mailId)
        .doc(subName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists){
        int attendanceCounter = documentSnapshot['Attendance Counter'];
        present = attendanceCounter.toDouble();
        FirebaseFirestore.instance
            .collection(mailId)
            .doc(subName)
            .collection("classes")
            .get()
            .then((querySnapshot) {
          numClasses = querySnapshot.size;
        });
        setState(() {
          absent = numClasses.toDouble() - present;
          percentage = (present / numClasses.toDouble()) * 100;
        });
        dataMap = {
          "Absent": absent,
          "Present": present,
        };
        setState(() {
          _isloading = true;
        });
      } else {
        _isloading = false;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (_isloading ? ShowAttendance(dataMap) : null),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.subject),
        closedForegroundColor: Colors.white,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.blue[900],
        openBackgroundColor: Colors.blue[900],
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.calendar_today),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Scheduled Classes',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ScheduledClass(subname: subName,mailId: mailId,teacherid: teacherid)));
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.assignment),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Assignment',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Assignment(subName: subName,userEmailId: mailId,teacherid: teacherid)));
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.assignment),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Post',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Posts(mailId: mailId,subName: subName,teacherid: teacherid)));
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.question_answer),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Vote',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StudentPadellete(mailId: mailId,subName: subName,teacherid: teacherid)));
            },
          ),
          //  Your other SpeeDialChildren go here.
        ],
      ),
    );
  }
}

class ShowAttendance extends StatelessWidget{
  Map<String, double> dataMap;
  ShowAttendance(this.dataMap);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            color: Colors.teal[100],
            width: MediaQuery.of(context).size.width * 0.7,
            height: 90,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                Text(" Present :" + present.toString()),
                Text("Absent :" + absent.toString()),
                Text("Percentage :" + percentage.toString() + "%"),
              ],
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 500),
            chartLegendSpacing: 52,
            chartRadius: MediaQuery.of(context).size.width / 2.0,
            initialAngleInDegree: 90,
            chartType: ChartType.ring,
            ringStrokeWidth: 100,
            centerText: "Attendance",
            legendOptions: const LegendOptions(
              showLegendsInRow: true,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
            ),
          ),
        ],
      ),
    );
  }
}