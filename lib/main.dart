import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:untitled1/pages/Bin.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/bin': (context) => Bin(),
        // add other pages here
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return Home(); // or Navigator.pushNamed(context, '/home');
          } else {
            return Login();
          }
        },
      ),
    );


    // return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: StreamBuilder(
    //         stream: FirebaseAuth.instance.authStateChanges(),
    //         builder:(context,snapshot) {
    //           if(snapshot.connectionState==ConnectionState.waiting){
    //             return  Center(
    //                 child: CircularProgressIndicator(),
    //               );
    //           }
    //           if(snapshot.data!=null){
    //             return Home();
    //           }
    //           return Login();
    //         }
    //     ),
    // );
  }
}