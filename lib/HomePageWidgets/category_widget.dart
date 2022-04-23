


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Category extends StatelessWidget {
  // final String inputText;
  // VoidCallback onpressed;

  // Buttonwithouticon({ required this.inputText,required this.onpressed,
  //
  // });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
          margin: EdgeInsets.only(left: 7, right: 5),
            // height: MediaQuery.of(context).size.height * 0.13,
            // width: MediaQuery.of(context).size.width * 0.10,
            decoration: BoxDecoration(
            ),
            child: Column(
              children: [
                Card(
                  child: Container(
                    height: 70,
                    width: 70,
                    padding: EdgeInsets.all(10),
                    // 2cdad0 f9b83a 3da8fe a74cff
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      // color: Color(0xFF2cdad0),
                    ),
                    child: Image.asset('assets/images/clothes.png',),
                  ),
                ),
                Text('Clothes')
              ],
            )
        );

  }
}

