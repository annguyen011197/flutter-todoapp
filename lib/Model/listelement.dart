import 'dart:ui';


import 'package:flutter/material.dart';

import './element.dart';
import 'package:firebase_database/firebase_database.dart';

class ListElement{
  String name;
  Color color;
  List<TaskElement> tasks;
  ListElement(this.name,this.color){
    tasks = List();
  }
  void addTask(TaskElement e){
    tasks.add(e);
  }
  void update(ListElement e){
    name = e.name;
    color = e.color;
    tasks = e.tasks;
  }
  static ListElement empty(){
    return ListElement("",Colors.lightBlue);
  }
}