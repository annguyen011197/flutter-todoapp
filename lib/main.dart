import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import './HomePage/homepage.dart';
import './TaskList/tasklist.dart';
import './CreateTask/createtask.dart';

//void main() => runApp(new MaterialApp(
//      home: new SplashScreen(),
//      routes: <String, WidgetBuilder>{
//        TaskList.route: (context) => TaskList(),
//        HomePage.route: (context) => HomePage()
//      },
//    ));

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        TaskList.route: (context) => TaskList(),
        HomePage.route: (context) => HomePage(),
        CreateTask.route: (context) => CreateTask(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void signOut() {
    firebaseAuth.signOut();
    print('Signed Out!');
  }

  Future<FirebaseUser> signInAnon() async {
    FirebaseUser user = await firebaseAuth.signInAnonymously();
    print("Signed in ${user.uid}");
    return user;
  }

  void navigationPage(FirebaseUser user) {
//    FirebaseDatabase.instance.reference().child(user.uid).push().set({'time':''}).then((_){
//      Navigator.of(context).push(MaterialPageRoute(
//          builder: (context) => HomePage(
//            user: user,
//          )));
//    }).catchError((err)=>print(err));
  FirebaseDatabase.instance.reference().child(user.uid).set({'time':'123'});

  }

  @override
  void initState() {
    super.initState();
    signInAnon().then((FirebaseUser user) {
      navigationPage(user);
    }).catchError((e) => debugPrint(e));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('images/list.png'),
      ),
    );
  }
}
