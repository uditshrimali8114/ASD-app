
import 'dart:async';


import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/registeredaccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
bool login= false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreference();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints.tight(size),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash.png'),
                fit: BoxFit.cover,
              ),
            ),

          )
        ],
      ),
    );
  }
  getPreference()async{
    var condition;
    setState(() {
      GetStorage box = GetStorage();
      //SharedPreferences preferences = await SharedPreferences.getInstance();
      condition = box.read("is_login");
      var Bottom = 0;
      Timer(
        Duration(seconds: 4),
            () {
          if (condition == true) {
            Get.off(()=>bottomBar(bottom: 0,));
          } else {
            Get.off(()=>LoginPage());
          }
        },
      );
    });
  }
}
