


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class CustomButton extends StatelessWidget {
  final String inputText;
  final Color background;
  VoidCallback onpressed;
  Widget trailingIcon;
  CustomButton({ required this.inputText,required this.background,required this.onpressed,
    required this.trailingIcon
    });

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 2,vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
            backgroundColor: MaterialStateProperty.all(background),
            padding: MaterialStateProperty.all(EdgeInsets.all(15)),

          ), onPressed: () {
          // controller.checkLogin();
          return onpressed();

        },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(inputText,style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w600),),
              _buildTrailingIcon(trailingIcon),

            ],
          ),
        ),),
    );
  }
}
Widget _buildTrailingIcon(Widget trailingIcon) {
  if (trailingIcon != null) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        trailingIcon,
      ],
    );
  }
  return Container();
}
