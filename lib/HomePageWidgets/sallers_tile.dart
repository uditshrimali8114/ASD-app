


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class SallersTile extends StatelessWidget {
  // final String inputText;
  // VoidCallback onpressed;

  // Buttonwithouticon({ required this.inputText,required this.onpressed,
  //
  // });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(

      // padding: EdgeInsets.symmetric(horizontal: 12.0, ),
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, itemBuilder: (context, index) {
        return Container(
          // height: 55,
          width:210,
          child: Card(
            child: ListTile(
              leading: Container(
                height: 60,
                width: 60,
                // padding: EdgeInsets.all(8.0),
                // margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffECECEC),
                ),
                child: Image.asset('assets/images/profileimg.png',),
              ),
              // CircleAvatar(
              //   radius: 35.0,
              //   backgroundImage: AssetImage('assets/images/addidas.png'),
              //   // backgroundImage:NetworkImage(profilepic),
              // ),
              title: Container(
                margin: EdgeInsets.only(top: 15),
                  child: Text('Addidas',style:TextStyle(fontSize: 16),)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("246 Products",style:TextStyle(fontSize: 14)),
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 10,
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
          ),
        );
      }),
    );
  }
}

