import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tuple/tuple.dart';
import 'package:urtask/FireBase/BaseAuth.dart';
import 'package:urtask/Model/listelement.dart';

import '../CreateTask/createtask.dart';
import '../Model/element.dart';
import '../Model/listelement.dart';
import '../TaskList/tasklist.dart';
import '../utils.dart';

class HomePage extends StatelessWidget {
  static final String route = "HomePage";
  final VoidCallback onSignOut;
  final BaseAuth auth;

  HomePage({this.auth, this.onSignOut});

  var list = ['mot', 'hai'];

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
            ),
            Expanded(
              child: AllListTask(
                auth: auth,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateTask(
                      auth: auth,
                    )));
          },
          elevation: 5.0,
          child: new Icon(Icons.add)),
    );
  }
}

class AllListTask extends StatefulWidget {
  final BaseAuth auth;

  AllListTask({this.auth});

  @override
  State<StatefulWidget> createState() => _AllListTask(auth: auth);
}

class _AllListTask extends State<AllListTask> {
  final BaseAuth auth;

  _AllListTask({this.auth}) {
    list = new List();
  }

  DatabaseReference _reference;
  List<Tuple2<String, ListElement>> list;

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    auth.currentUser().then((id) {
      database.reference().child(id).child('task').onChildAdded.listen((e) {
        _onChildAdded(e.snapshot);
      });
      database.reference().child(id).child('task').onChildRemoved.listen((e) {
        _onChildRemoved(e.snapshot);
      });
      database.reference().child(id).child('task').onChildChanged.listen((e) {
        _onChildChanged(e.snapshot);
      });
    });
  }

  void _onChildChanged(DataSnapshot snapshot) {
    if (this.mounted)
      setState(() {
        list
            .firstWhere((item) => item.item1 == snapshot.key)
            .item2
            .update(_listElementParser(snapshot));
      });
  }

  void _onChildAdded(DataSnapshot snapshot) {
    try {
      setState(() {
        list.add(Tuple2<String, ListElement>(
            snapshot.key, _listElementParser(snapshot)));
      });
    } catch (err) {
      print(err);
    }
  }

  void _onChildRemoved(DataSnapshot snapshot) {
    setState(() {
      list.removeWhere((item) => item.item1 == snapshot.key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: list.length,
      itemBuilder: (ctx, index) => Padding(
            padding: EdgeInsets.all(2.0),
            child: GestureDetector(
              child: ListElementUI(
                item: list.elementAt(index).item2,
              ),
              onTap: () {
                navigationToTaskList(list.elementAt(index).item1);
              },
            ),
          ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  void navigationToTaskList(String key) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TaskList(
              user: auth,
              firebaseKey: key,
            )));
  }

  ListElement _listElementParser(DataSnapshot snap) {
    var e = ListElement.empty();
    e.name = snap.value['name'];
    e.color = Utils.getColor(snap.value['color']);
    Map<dynamic, dynamic> map = snap.value['list'] ?? Map();
    map.forEach((key, item) {
      if (item['value'] is String) {
        var i = TaskElement(name: item['value'], isDone: item['done'] ?? false);
        e.addTask(i);
      }
    });
    return e;
  }
}

class ListElementUI extends StatelessWidget {
  final ListElement item;

  ListElementUI({this.item});

  List<Widget> _list() {
    var l = List<Widget>();
    //l.add(Text(item.name));
    item.tasks.forEach((i) => l.add(Padding(
          padding: EdgeInsets.only(bottom: 3.0),
          child: Text(
            i.name,
            style: TextStyle(
                decoration: i.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        )));
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              item.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: EdgeInsets.only(top: 3.0),
              color: Colors.black87,
              height: 1.5,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                children: _list(),
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                blurRadius: 5.0,
                offset: Offset(3.0, 3.0))
          ]),
    );
  }
}
