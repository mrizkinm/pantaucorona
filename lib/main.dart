import 'package:flutter/material.dart';
import 'package:pantaucorona/launcher_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pantau Corona',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        fontFamily: 'Lato',
        appBarTheme: AppBarTheme(
          elevation: 0
        )
      ),
      home: LauncherPage(),
    );
  }
}
