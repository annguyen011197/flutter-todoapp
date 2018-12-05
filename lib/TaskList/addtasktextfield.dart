import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddTaskTextField extends StatefulWidget {
  final void Function(String) onPress;
  final Color color;

  @override
  State<StatefulWidget> createState() => TextState(onPress,color);

  const AddTaskTextField({Key key, @required this.onPress, this.color})
      : super(key: key);
}

class TextState extends State<AddTaskTextField> {
  final controller = TextEditingController();
  void Function(String) onPress;
  Color color;

  TextState(onPress,color) {
    this.onPress = onPress;
    if(color !=null){
      this.color = color;
    }else{
      this.color = Colors.lightBlue;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: this.color, width: 2.0),
              ),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    this.sendText(controller.text);
                  })),
          onSubmitted: (text) => this.sendText(text),
        ));
  }

  void sendText(String text) {
    if (text.trim().length <= 0) return;
    controller.clear();
    this.onPress(text);
  }
}
