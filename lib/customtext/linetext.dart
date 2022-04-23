
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class LineTextPage extends StatefulWidget {
  final String text;

  LineTextPage({required this.text,});

  @override
  _LineTextPageState createState() => _LineTextPageState();
}

class _LineTextPageState extends State<LineTextPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Container(
        width: size.width*0.85,

        child: Text(widget.text,textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey,
              fontSize: 18,fontWeight: FontWeight.w400,
          ),));
  }
}
