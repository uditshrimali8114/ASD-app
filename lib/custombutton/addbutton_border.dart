


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class AddButtonBorder extends StatelessWidget {
  // final String inputText;
  // VoidCallback onpressed;

  // Buttonwithouticon({ required this.inputText,required this.onpressed,
  //
  // });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      FlatButton(onPressed: () {  },
        child: Text('Add to cart',style: TextStyle(color: Colors.white),),
        color: Color(0xFFc01211) ,
      );
  }
}







