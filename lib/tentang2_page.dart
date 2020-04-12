import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class Tentang2Page extends StatefulWidget {
  @override
  _Tentang2PageState createState() => _Tentang2PageState();
}

class _Tentang2PageState extends State<Tentang2Page> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: bodyWidget()
    );
  }

  Widget bodyWidget() {
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 11),
            Text('Pantau Corona', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 25)),
            Spacer(flex: 1),
            Text('Versi '+_packageInfo.version, style: TextStyle(color: Colors.white)),
            Spacer(flex: 1),
            Hero(
              tag: 'pc',
              child: Image(
                width: 96,
                image: AssetImage('assets/images/virus.png'),
                fit: BoxFit.contain
              ),
            ),
            Spacer(flex: 1),
            Text('Data pasien diambil dari api.kawalcorona.com', style: TextStyle(color: Colors.white)),
            Text('Gambar icon berasal dari icons8.com', style: TextStyle(color: Colors.white)),
            Spacer(flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  width: 40,
                  image: AssetImage('assets/images/github.png'),
                  fit: BoxFit.contain
                ),
                Image(
                  width: 31,
                  image: AssetImage('assets/images/ig.png'),
                  fit: BoxFit.contain
                ),
                Image(
                  width: 37,
                  image: AssetImage('assets/images/twitter.png'),
                  fit: BoxFit.contain
                ),
                Text('mrizkinm', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 20)),
              ],
            ),
            Spacer(flex: 11),
          ],
        ),
      )
    );
  }
}