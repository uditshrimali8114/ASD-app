
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {




  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.transparent,
      title: Image.asset('assets/images/menu.png',),
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
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/menu.png',),
      ),
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