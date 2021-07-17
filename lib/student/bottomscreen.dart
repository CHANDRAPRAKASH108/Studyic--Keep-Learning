import 'package:educationstudyic/student/homepageui.dart';
import 'package:educationstudyic/student/profilepage.dart';
import 'package:flutter/material.dart';
import 'classes/classoverview.dart';
class HomeStudent extends StatefulWidget {
  @override
  _HomeStudentState createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    @override
    final List<Widget> _children = [
      HomePageUI(),
      ClassOverview(),
      ProfileStudent(),
    ];
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) =>
            setState(() {
              _currentIndex = i;
              //print('$selectedIndex Selected!');
            }),
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            // ignore: prefer_const_literals_to_create_immutables, prefer_const_literals_to_create_immutables
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.class__outlined),
            label: 'My Classroom',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              label: 'Profile')
        ],
        selectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
