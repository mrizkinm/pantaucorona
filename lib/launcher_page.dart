import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pantaucorona/landing_page.dart';

class LauncherPage extends StatefulWidget {

  @override
  _LauncherPageState createState() => new _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  @override

  void initState() {
    super.initState();
    startLaunching();
  }

  startLaunching() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (_) {
        return LandingPage();
      }));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                width: 96,
                image: AssetImage('assets/images/virus.png'),
                fit: BoxFit.contain
              ),
              Text('Pantau Corona', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 25)),
            ],
          ),
        ),
      ),
    );
  }
}