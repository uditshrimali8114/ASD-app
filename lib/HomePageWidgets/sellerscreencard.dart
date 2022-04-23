


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class SellerCard extends StatelessWidget {
  // final String inputText;
  // VoidCallback onpressed;

  // Buttonwithouticon({ required this.inputText,required this.onpressed,
  //
  // });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.50,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.90,
        decoration: BoxDecoration(
        ),
        child: Card(
          // margin:  EdgeInsets.only(left: 5,right: 5),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                // height: 120,s
                child: Image.asset('assets/images/product01.png',
                  alignment: Alignment.center,),
              ),
              Row(

                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(12, 7, 0, 10),
                      child: Image.asset('assets/images/like.png')),
                  Container(
                      margin: EdgeInsets.fromLTRB(12, 7, 0, 10),
                      child: Text("250 Likes", style: TextStyle(color: Color(0xffC1C1C1)),)),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(15, 7, 0, 5),
                      child: Text("Men's Cotton T-shirt", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                  Container(
                      margin: EdgeInsets.fromLTRB(12, 7, 12, 10),
                      child: Text("\$11", style: TextStyle(color: Color(0xff708090),fontSize: 16),)
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(margin: EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Text("New Home Delivery",style:TextStyle(color: Color(0xff708090),fontSize: 16) ,),
              ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    height:25,
                    width:60,

                    child: FlatButton(
                      onPressed: (){},
                    child : Text("\$10",style: TextStyle(color: Colors.white),),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                      ),
                      color: Color(0xFFe81818),
                    ),
                  )
                ],
              ),

            ],
          ),

        )
    );
  }
}

