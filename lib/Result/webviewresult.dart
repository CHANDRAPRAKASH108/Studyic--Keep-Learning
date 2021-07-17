import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewResult extends StatefulWidget {
  String Link;
  WebViewResult({required this.Link});
  @override
  _WebViewResultState createState() => _WebViewResultState(Link);
}

class _WebViewResultState extends State<WebViewResult> {
  String Link;
  _WebViewResultState(this.Link);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowPage(Link)),
    );
  }
}

class ShowPage extends StatelessWidget{
  String Link;
  ShowPage(this.Link);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30.0),
        // ignore: prefer_const_literals_to_create_immutables
        child: Column(children: <Widget>[
          // ignore: prefer_const_constructors
          Expanded(
              child: const InAppWebView(

        ),
          )
        ])
    );
  }
}
