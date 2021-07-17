import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class ShowPdf extends StatefulWidget {
  final value;
  ShowPdf({this.value});
  @override
  _ShowPdfState createState() => _ShowPdfState(value);
}

class _ShowPdfState extends State<ShowPdf> {
  String value='';
  _ShowPdfState(this.value);
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPdf();
  }

  _initPdf() async {
    setState(() {
      _loading = true;
    });
    setState(() {
      //_doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer', style: TextStyle(fontStyle: FontStyle.italic),),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: _loading ? Center(child: CircularProgressIndicator(),) :
      SfPdfViewer.network(
          value,
          canShowScrollHead: false,
          canShowScrollStatus: false));
  }
}