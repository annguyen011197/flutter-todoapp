import 'dart:ui';

class Utils{
  static Color getColor(String hexColor){
    if(hexColor == null || hexColor.length ==0){
      return Color.fromRGBO(255, 255, 255, 1.0);
    }
    String valueString = hexColor.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }
}