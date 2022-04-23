


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ProductCard extends StatelessWidget {
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

    return Container(
        // height: 250,
        width: width*0.55,
        decoration: BoxDecoration(
        ),
        child: Card(
          margin:  EdgeInsets.only(left: 5,right: 5),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                height: 100,
                child: Image.asset('assets/images/shoes.jpg',
                  alignment: Alignment.center,),
              ),
              Row(
                children: [
                  Container(margin: EdgeInsets.only(left: 10),
                      child: Image.asset('assets/images/like.png')),
                  Container(margin: EdgeInsets.only(left: 10),
                      child: Text("250 likes",style: TextStyle(color: Color(0xffC1C1C1))))
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10,left: 5),
                    child: Text("Motorsport Shoes For Men",maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10,left: 5),
                    child: Text("Free Shipping ",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xffEC1B23))),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(margin: EdgeInsets.only(top: 15,left: 5),
                    child: Text("\$11",style:TextStyle(color:Color(0xff708090),fontSize: 18 ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15,right: 5),
                    child:FlatButton(
                      onPressed: null,
                      child: Text('Add', style: TextStyle(
                          color:  Color(0xffEC1B23)
                      )
                      ),
                      textColor: Color(0xffEC1B23),
                      shape: RoundedRectangleBorder(side: BorderSide(
                          color:  Color(0xffEC1B23),
                          width: 1,
                          style: BorderStyle.solid
                      ), borderRadius: BorderRadius.circular(10)),
                    )
                  )


                ],
              ),

            ],
          ),

        )
    );
  }
}

