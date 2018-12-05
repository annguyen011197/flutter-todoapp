import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CreateTask extends StatefulWidget {
  static final String route = "CreateTask";
  final FirebaseUser user;

  CreateTask({this.user});

  @override
  State<StatefulWidget> createState() => _State(user);
}

class _State extends State<CreateTask> {
  final controller = TextEditingController();
  FirebaseUser user;
  _State(this.user);
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

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
                'New List',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              color: Colors.grey,
              height: 1.5,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder()
                ),
              ),
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: (){
                FirebaseDatabase.instance.reference().child(user.uid).child('task').push().set({'name':controller.text});
              },
            )
          ],
        ),
      ),
    );
  }
}
