import 'package:flutter/material.dart';
import './addtasktextfield.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: new AppBar(
        title: new Text("Task name",
            style: TextStyle(
              fontSize: 20,
            )),
        centerTitle: true,
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AddTaskTextField(
              onPress: (text){
                debugPrint(text);
              },
            )
          ],
        ),
      ),
    );
  }
}
