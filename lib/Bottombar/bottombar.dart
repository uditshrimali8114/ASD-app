
import 'package:asd/screens/Orderhistory.dart';
import 'package:asd/screens/SellerProfile.dart';
import 'package:asd/screens/chat.dart';
import 'package:asd/screens/editaddress.dart';
import 'package:asd/screens/home.dart';
import 'package:asd/screens/notification.dart';
import 'package:flutter/material.dart';


// Stateful widget created
class bottomBar extends StatefulWidget {
  int bottom;
  bottomBar({required this.bottom});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<bottomBar> {
// index given for tabs
  int currentIndex = 0;
  int _selectedItemIndex = 2;
  final List pages = [
    // Allrecipescreen(),
    // Recipedetailscreen(),
    HomePage(),
    ChatPage(),
    SellerProfilePage(),
    OrderHistoryPage(),
    NotificationPage()
    // Postscreen(),
  ];
  setBottomBarIndex(index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedItemIndex = widget.bottom == null ? 0 : widget.bottom;
    });
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: pages[_selectedItemIndex],

      // floating action button in center
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setBottomBarIndex(2);
      //   },
      //   child:  Container(
      //     width: 100.0,
      //     height: 100.0,
      //     decoration: BoxDecoration(
      //       // color: BackColorCard,
      //       color: Colors.white.withOpacity(1),
      //       boxShadow: [
      //         BoxShadow(
      //             color: Colors.grey.shade200
      //                 .withOpacity(.1),
      //             blurRadius: 4,
      //             spreadRadius: 3)
      //       ],
      //       border: Border.all(
      //         width: 5,
      //         color: Colors.grey,
      //       ),
      //       borderRadius: BorderRadius.circular(50.0),
      //     ),
      //     padding: EdgeInsets.all(5),
      //     child: Image.asset("assets/images/home.png",
      //       height: 25,
      //       width: 25,),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottom app bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Container(
          margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 0.5),
            borderRadius: BorderRadius.circular(15)
          ),
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // button 1
              IconButton(
                icon: Image.asset('assets/images/message.png',color: _selectedItemIndex==1?Color(0xffEC1B23):Color(0xFF708090)),
                onPressed: () {
                  setBottomBarIndex(1);
                },
                splashColor: Colors.white,
              ),

              // button 2
              IconButton(
                icon: Image.asset('assets/images/profile.png',color: _selectedItemIndex==2?Color(0xffEC1B23):Color(0xFF708090)),
                onPressed: () {
                  setBottomBarIndex(2);
                },
                splashColor: Colors.white,
              ),
              // SizedBox.shrink(),

              // button 3
              IconButton(
                icon: Image.asset('assets/images/home.png',color: _selectedItemIndex==0?Color(0xffEC1B23):Color(0xFF708090)),
                onPressed: () {
                  setBottomBarIndex(0);
                },
                splashColor: Colors.white,
              ),

              // button 4
              IconButton(
                icon:Image.asset('assets/images/timer.png',color: _selectedItemIndex==3?Color(0xffEC1B23):Color(0xFF708090)),
                onPressed: () {
                  setBottomBarIndex(3);
                },
                splashColor: Colors.white,
              ),
              // button 5
              IconButton(
                icon: Image.asset('assets/images/bell.png',color: _selectedItemIndex==4?Color(0xffEC1B23):Color(0xFF708090)),
                onPressed: () {
                  setBottomBarIndex(4);
                },
                splashColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildNavBarItem(IconData icon, Text text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
          print("_selectedItemIndex"+_selectedItemIndex.toString());
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        height: 60,
        //  border:
        //     Border(bottom: BorderSide(width: 4, color: kSecondaryLightColor)),
        //     gradient: LinearGradient(colors: [
        //       kSecondaryLightColor.withOpacity(0.3),
        //       kSecondaryLightColor.withOpacity(0.016),
        //     ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
        //     : BoxDecoration( ),
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              color: index == _selectedItemIndex
                  ? Color(0xffEC1B23)
                  : Colors.blueAccent[500],
            ),

          ],
        ),
      ),
    );
  }
}
