import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:urtask/FireBase/BaseAuth.dart';

class CreateTask extends StatefulWidget {
  static final String route = "CreateTask";
  final BaseAuth auth;

  CreateTask({this.auth});

  @override
  State<StatefulWidget> createState() => _State(auth);
}

class _State extends State<CreateTask> {
  final controller = TextEditingController();
  BaseAuth auth;
  _State(this.auth);
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
                auth.currentUser().then((id){
                  FirebaseDatabase.instance.reference().child(id).child('task').push().set({'name':controller.text});
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
