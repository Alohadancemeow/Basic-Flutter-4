import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _scanResult = '...';
  bool _isYoutube = false;
  bool _isLineLink = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Card(
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result of scan',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //show result ->
                  Text(_scanResult),
                  Spacer(),

                  //check youtube link ->
                  _isYoutube
                      ? SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                              color: Colors.red,
                              onPressed: () async {
                                //open link ->
                                if (await canLaunch(_scanResult)) {
                                  //check platfrom (os)
                                  if (Platform.isIOS) {
                                    await launch(_scanResult,
                                        forceSafariVC: false);
                                  } else {
                                    await launch(_scanResult);
                                  }
                                }
                              },
                              child: Text(
                                'Open youtube',
                                style: TextStyle(color: Colors.white),
                              )))
                      : SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                              color: Colors.red,
                              onPressed: () {},
                              child: Text(
                                'Not youtube link!',
                                style: TextStyle(color: Colors.white),
                              ))),

                  //check line link ->
                  _isLineLink
                      ? SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              if (await canLaunch(_scanResult)) {
                                if (Platform.isIOS) {
                                  await launch(_scanResult,
                                      forceSafariVC: false);
                                } else {
                                  await launch(_scanResult);
                                }
                              }
                            },
                            child: Text(
                              'Open line',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),

      //Scan Button ->
      floatingActionButton: RaisedButton(
        onPressed: () {
          startScan();
        },
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: SizedBox(
          width: 150,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
              Text(
                'QR code Scan',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  startScan() async {
    var colorCode = ''; //Scan line
    var cancelButtonText = ''; //Cancel button
    var isShowFlashIcon = true; //Flash light
    var scanMode = ScanMode.DEFAULT;

    //get scan results
    var scanResult = await FlutterBarcodeScanner.scanBarcode(
        colorCode, cancelButtonText, isShowFlashIcon, scanMode);

    print("Scanned: $scanResult");

    //reset to false
    _isYoutube = false;
    _isLineLink = false;

    //if users cancelled scanning,
    //it will return '-1'
    if (scanResult != '-1') {
      //check type of link ->
      if (scanResult.contains('youtube.com')) {
        _isYoutube = true;
      } else if (scanResult.contains('line.me')) {
        _isLineLink = true;
      }

      //change state
      setState(() {
        _scanResult = scanResult;
      });
    }
  }
}
