import 'package:flutter/material.dart';
import 'screens/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.deepOrange, primaryColor: Colors.white
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
