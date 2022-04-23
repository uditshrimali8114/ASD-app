
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({

    required this.title,

  }) ;

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.transparent,
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xffEC1B23),Color(0xffEC1B23)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight

            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
        ),
      ),
      //leading: Icon(Icons.arrow_back,size: 30,),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/search.png',scale: 2.5,),
              SizedBox(width: 20,),
              Image.asset('assets/images/cart.png',scale: 2.5,),
            ],
          ),
        ),
      ],
    );
  }
}