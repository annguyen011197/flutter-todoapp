import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../CreateTask/createtask.dart';
import 'package:urtask/FireBase/BaseAuth.dart';
class HomePage extends StatelessWidget {
  static final String route = "HomePage";
  final VoidCallback onSignOut;
  final BaseAuth auth;

  HomePage({this.auth, this.onSignOut});

//  void navigationPage(FirebaseUser user) {
//    Navigator.of().push(MaterialPageRoute(
//        builder: (context) => HomePage(
//          user: user,
//        )));
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Image.asset('images/list.png'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'UrTask',
                style: TextStyle(fontSize: 25.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateTask(auth: auth,)));
          }, elevation: 5.0, child: new Icon(Icons.add)),
    );
  }
}
