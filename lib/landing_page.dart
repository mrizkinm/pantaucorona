import 'package:flutter/material.dart';
import 'package:pantaucorona/indonesia_page.dart';
import 'package:pantaucorona/global_page.dart';
import 'dart:io';

class LandingPage extends StatefulWidget {
  LandingPage({this.screens});

  final List<Widget> screens;
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  int _bottomNavCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    checkConnect().then((status) async {
      if (status == true) {
        
      } else {
        _showDialog('Koneksi internet error');
      }
    });
  }
  
  Future checkConnect() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
     return false;
    }
  }

  void _showDialog(msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Error'),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavCurrentIndex,
        children: <Widget>[
          IndonesiaPage(),
          GlobalPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar()
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Color(0xff666666),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomNavCurrentIndex = index;
          });
        },
        currentIndex: _bottomNavCurrentIndex,
        items: [
          BottomNavigationBarItem(
            activeIcon: Image(
              width: 27,
              image: AssetImage('assets/images/indo_active.png'),
              fit: BoxFit.contain
            ),
            icon: Image(
              width: 27,
              image: AssetImage('assets/images/indo.png'),
              fit: BoxFit.contain
            ),
            title: Text('Indonesia'),
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
              width: 30,
              image: AssetImage('assets/images/globe_active.png'),
              fit: BoxFit.contain
            ),
            icon: Image(
              width: 30,
              image: AssetImage('assets/images/globe.png'),
              fit: BoxFit.contain
            ),
            title: Text('Global'),
          )
        ],
      );
  }
}