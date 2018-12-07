import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

import './addtasktextfield.dart';
import '../FireBase/BaseAuth.dart';
import '../Model/element.dart';
import '../utils.dart';

class TaskList extends StatefulWidget {
  static final String route = "TaskList";
  final BaseAuth user;
  final String firebaseKey;

  TaskList({this.user, this.firebaseKey});

  @override
  State<StatefulWidget> createState() =>
      _State(auth: user, firebaseKey: firebaseKey);
}

class _State extends State<TaskList> {
  List<TaskElement> litems;
  List<Tuple2<String, TaskElement>> list;
  int isDone = 0;
  final BaseAuth auth;
  final String firebaseKey;

  // create some value
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  ValueChanged<Color> onColorChanged;
  FirebaseDatabase _database;
  DatabaseReference _reference;

  _State({@required this.auth, @required this.firebaseKey}) {
    list = List();
    _database = FirebaseDatabase.instance;
    auth.currentUser().then((id) {
      _reference = _database
          .reference()
          .child(id)
          .child("task")
          .child(firebaseKey)
          .reference();
    });
  }

  @override
  void initState() {
    checkDone();
    auth.currentUser().then((id) {
      DatabaseReference _listRef = _database
          .reference()
          .child(id)
          .child("task")
          .child(firebaseKey)
          .child("list");
      _listRef.onChildAdded.listen((e) {
        _OnChildAdded(e.snapshot);
      });
      _listRef.onChildRemoved.listen((e) {
        _onChildRemoved(e.snapshot);
      });
      _listRef.onChildChanged.listen((e) {
        _onChildChanged(e.snapshot);
      });
      _database
          .reference()
          .child(id)
          .child("task")
          .child(firebaseKey)
          .onValue
          .listen((e) {
        _onValueChanged(e.snapshot);
      });
    });
  }

  void checkDone() {
    isDone = 0;
    list.forEach((e) {
      isDone += e.item2.isDone ? 1 : 0;
    });
  }

  void _onValueChanged(DataSnapshot snapshot) {
    Color color = Utils.getColor(snapshot.value['color']);
    if (this.mounted)
      setState(() {
        currentColor = color;
      });
  }

  void _onChildChanged(DataSnapshot snapshot) {
    String name = snapshot.value['value'];
    bool isdone = snapshot.value['done'];
    if (this.mounted) {
      setState(() {
        list
            .firstWhere((item) {
              return item.item1 == snapshot.key;
            })
            .item2
            .set(name, isdone);
      });
      checkDone();
    }
  }

  void _OnChildAdded(DataSnapshot snapshot) {
    debugPrint(snapshot.value['value']);
    String name = snapshot.value['value'];
    bool isdone = snapshot.value['done'];
    setState(() {
      list.add(Tuple2<String, TaskElement>(
          snapshot.key, TaskElement(name: name, isDone: isdone)));
      checkDone();
    });
  }

  void _onChildRemoved(DataSnapshot snapshot) {
    if (this.mounted)
      setState(() {
        list.removeWhere((item) {
          return item.item1 == snapshot.key;
        });
        checkDone();
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
            onPressed: () {
              Navigator.of(context).pop();
            }),
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
              onPressed: () {
                if (_reference != null) {
                  _reference.remove();
                }
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AddTaskTextField(
              onPress: (text) {
                if (_reference != null) {
                  _reference
                      .child('list')
                      .push()
                      .set({"value": text, "done": false});
                }
              },
              color: currentColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "${isDone} of ${list.length} tasks",
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
                                _reference
                                    .update({'color': pickerColor.toString()});
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
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (ctx, index) => Slidable(
                          delegate: SlidableDrawerDelegate(),
                          actionExtentRatio: 0.3,
                          child: new Container(
                            color: Colors.white,
                            child: listItem(list.elementAt(index).item2, index),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              icon: Icons.delete,
                              color: Colors.redAccent,
                              caption: 'Delete',
                              onTap: () {
                                if (_reference != null) {
                                  _reference
                                      .child('list')
                                      .child(list.elementAt(index).item1)
                                      .remove();
                                }
                              },
                            )
                          ],
                        )))
          ],
        ),
      ),
    );
  }

  Widget listItem(TaskElement item, int index) {
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
            if (_reference != null) {
              _reference
                  .child('list')
                  .child(list.elementAt(index).item1)
                  .update({'done': !list.elementAt(index).item2.isDone});
            }
//            setState(() {
//              checkDone();
//            });
          }),
    );
  }
}
