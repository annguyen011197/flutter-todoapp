import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddTaskTextField extends StatefulWidget {
  final void Function(String) onPress;

  @override
  State<StatefulWidget> createState() => TextState(onPress);

  const AddTaskTextField({Key key, @required this.onPress}) : super(key: key);
}

class TextState extends State<AddTaskTextField> {
  final controller = TextEditingController();
  void Function(String) onPress;

  TextState(onPress) {
    this.onPress = onPress;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(8.0), child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: IconButton(icon: Icon(Icons.add), onPressed: (){
          this.onPress(controller.text);
        })
      ),
    ));
  }
}
