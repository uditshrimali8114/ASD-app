


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Buttonwithouticon extends StatelessWidget {
  final String inputText;
  VoidCallback onpressed;

  Buttonwithouticon({ required this.inputText,required this.onpressed,

  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Color(0xffEC1B23)),
            padding: MaterialStateProperty.all(EdgeInsets.all(15)),

          ), onPressed: () {
          // controller.checkLogin();
          return onpressed();

        },
          child: Text(inputText,
            style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w600),),
        ),),
    );
  }
}

