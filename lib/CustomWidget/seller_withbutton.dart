


import 'package:asd/custombutton/Buttonwithouticon.dart';
import 'package:asd/custombutton/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class SallersWithButton extends StatelessWidget {
  // final String inputText;
  // VoidCallback onpressed;

  // Buttonwithouticon({ required this.inputText,required this.onpressed,
  //
  // });
var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Column(

      children:[
        ListTile(
        leading: Container(
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffECECEC),
          ),
          child: Image.asset('assets/images/profileimg.png',),
        ),
        title: Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Addidas',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text("See All", style: TextStyle(fontSize: 14, color: Color(0xFFc01211)),),
              ],
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("246 Products",style:TextStyle(fontSize: 16)),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 15,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Color(0xFFc01211),
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                Text("(120)",style: TextStyle(fontSize: 10),)
              ],
            )
          ],
        ),
        isThreeLine: true,
      ),
        Container(
          margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: width*0.45,
                child: FlatButton(
                  child:  Text('Follow', style: TextStyle(fontSize: 18.0,color: Colors.white),),
                  color: Color(0xFFe81818),
                  textColor: Colors.white,
                  onPressed: () {},
                  // {
                  //   Navigator.push(
                  //       context, MaterialPageRoute(builder: (context) => Dashboard()));
                  // },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)
                  ),
                ),
              ),
              Container(
                width: width*0.45,
                child: FlatButton(
                  // height: height*0.06,
                  child:  Text('Message', style: TextStyle(fontSize: 18.0),),
                  color: Color(0xFFfbd8d6),
                  textColor: Color(0xFFe81818),
                  onPressed: () {},
                  // {
                  //   Navigator.push(
                  //       context, MaterialPageRoute(builder: (context) => Dashboard()));
                  // },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)
                  ),
                ),
              ),

            ],
          ),
        )
]
    );
  }
}

