
import 'package:asd/Appbar/Customappbar.dart';
import 'package:asd/Appbar/HomeAppbar.dart';
import 'package:asd/HomePageWidgets/category_widget.dart';
import 'package:asd/HomePageWidgets/productcard.dart';
import 'package:asd/HomePageWidgets/sallers_tile.dart';
// import 'package:asd/customproductdetail/productcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      // backgroundColor: Colors.white,
      appBar:AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Image.asset('assets/images/logo.png',scale: 2.5,),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(

              color: Color(0xffEC1B23),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25))
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset('assets/images/menu.png',),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/search.png',scale: 3,),
                SizedBox(width: 20,),
                Image.asset('assets/images/cart.png',scale: 3,),
                SizedBox(width: 10,),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        width: 350,
        height: 600,
        child: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Category(),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Sallers", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Text("See All", style: TextStyle(fontSize: 14, color: Color(0xFFc01211)),),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SallersTile(),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Popular", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Text("See All", style: TextStyle(fontSize: 14, color: Color(0xFFc01211)),),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 5,),
                  child: ProductCard()),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Favorite items", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Text("See All", style: TextStyle(fontSize: 14, color: Color(0xFFc01211)),),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 5,),
                  child: ProductCard()),
            ],
          ),
        ),
      ),

    );
  }
}
