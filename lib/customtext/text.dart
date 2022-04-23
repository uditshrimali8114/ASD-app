
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class TextPage extends StatefulWidget {
  final String text;

  TextPage({required this.text,});

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Container(
        width: size.width*0.8,

        child: Text(widget.text,textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xffEC1B23),
            fontSize: 24,fontWeight: FontWeight.w600
          ),));
  }
}
