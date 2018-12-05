import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './addtasktextfield.dart';
import '../Model/element.dart';

class TaskList extends StatefulWidget {
  static final String route = "TaskList";
  final FirebaseUser user;

  TaskList({this.user});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TaskList> {
  List<TaskElement> litems = [TaskElement('ABCCSSSD'), TaskElement('3000000')];
  int isDone = 0;

  // create some value
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  ValueChanged<Color> onColorChanged;

  @override
  void initState() {
    checkDone();
  }

  void checkDone() {
    isDone = 0;
    litems.forEach((e) {
      isDone += e.isDone ? 1 : 0;
    });
  }

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: null),
        title: Text("Task name",
            style: TextStyle(fontSize: 20, color: Colors.white70)),
        centerTitle: true,
        backgroundColor: currentColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesomeIcons.trash,
                color: Colors.white70,
              ),
              onPressed: null)
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AddTaskTextField(
              onPress: (text) {
                setState(() {
                  litems.insert(0, TaskElement(text));
                });
              },
              color: currentColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "${isDone} of ${litems.length} tasks",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      FontAwesomeIcons.eyeDropper,
                      color: currentColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                              enableLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Got it'),
                              onPressed: () {
                                setState(() => currentColor = pickerColor);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 50.0),
              color: Colors.grey,
              height: 1.5,
            ),
            Expanded(
                child: DragAndDropList<TaskElement>(
              litems,
              itemBuilder: (context, item) => Slidable(
                    delegate: SlidableDrawerDelegate(),
                    actionExtentRatio: 0.3,
                    child: new Container(
                      color: Colors.white,
                      child: listItem(item),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        icon: Icons.delete,
                        color: Colors.redAccent,
                        caption: 'Delete',
                        onTap: () {
                          setState(() {
                            litems.remove(item);
                            checkDone();
                          });
                        },
                      )
                    ],
                  ),
              canBeDraggedTo: (one, two) => true,
              onDragFinish: (before, after) {
                TaskElement e = litems[before];
                litems.removeAt(before);
                litems.insert(after, e);
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget listItem(TaskElement item) {
    return ListTile(
      title: Text(item.name,
          style: TextStyle(
            decoration:
                item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
            color: item.isDone ? Colors.black54 : currentColor,
            fontSize: 20.0,
          ),
          overflow: TextOverflow.ellipsis),
      leading: IconButton(
          icon: Icon(
            item.isDone
                ? FontAwesomeIcons.checkSquare
                : FontAwesomeIcons.square,
            color: item.isDone ? Colors.black54 : currentColor,
          ),
          onPressed: () {
            int i = litems.indexOf(item);
            setState(() {
              litems.elementAt(i).isDone = !litems.elementAt(i).isDone;
              checkDone();
            });
          }),
    );
  }
}
