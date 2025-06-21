import "package:flutter/material.dart";
import 'package:untitled1/pages/Home.dart';

import 'package:untitled1/pages/template.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,

        home: Home(),
    );
  }
}