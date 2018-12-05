import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:urtask/FireBase/BaseAuth.dart';
import 'package:urtask/FireBase/RootPage.dart';

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

  void navigationPage() {
//    FirebaseDatabase.instance.reference().child(user.uid).push().set({'time':''}).then((_){
//      Navigator.of(context).push(MaterialPageRoute(
//          builder: (context) => RootPage(
//            auth: new Auth(),
//          )));
//    }).catchError((err)=>print(err));
//  FirebaseDatabase.instance.reference().child(user.uid).set({'time':'123'});

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RootPage(
          auth: new Auth(),
        )));

  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
//    signInAnon().then((FirebaseUser user) {
//      navigationPage(user);
//    }).catchError((e) => debugPrint(e));
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
