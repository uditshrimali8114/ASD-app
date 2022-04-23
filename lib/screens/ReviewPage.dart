import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:asd/custombutton/Buttonwithouticon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _ratingBarMode = 1;
  double _initialRating = 2.0;
  bool _isVertical = false;
  List prevPage = [];
  var prodId, orderId,token;
  double _rating = 0.0;
  GetStorage box = GetStorage();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController descriptioncontroller= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prevPage = Get.arguments;
    prodId = prevPage[0];
    orderId = prevPage[1];

  }

  Future getData() async {
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });

  }


  Future<void> submitReview(token) async {


    String url = ApiConfig().baseurl + ApiConfig().api_rating_review + prodId.toString();
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    //
    var headers = {
    'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'XSRF-TOKEN=eyJpdiI6IjQvWGo1MTJ5YlRONUh4VnkxWEQxdFE9PSIsInZhbHVlIjoiRWk0azczS0c3SDRPSlFocE96ZjFqWnk0aDJYb0F0dG1SWWZ1bE5pcHo3MmlFVXF0SjkrQ2JpL0RxNm9aRzNoYmxEQmMwVExvbDZJblB5R3MxbE5mWnFRU1Boa3lwc3ZMaUJ4TlA3L3NtRmd3WU9Qa21mYjlqbUxhM0ZsZWZnZjQiLCJtYWMiOiI5NjY0MzEwNGVlYWViMmFjZGQ0OGY4MzhmM2VmYjVmMDQ4M2Q4OTQ2MjkyZGU2YjkwY2VjMDhjMzU4NGFkNzA1IiwidGFnIjoiIn0%3D; asd_session=eyJpdiI6IjRjdzJjTFRkZU9yNHpEZ0hPQnFlRFE9PSIsInZhbHVlIjoicGhmQWNxelh1UG5tZUY3dkM3dlRSMUhJU3E5S3JBMmsvZnJCL1NONWdEQUdZY1FoNXR6NmNkVDRETGxvczM0QlpGdW9pZW1ubHNtdFAzWUNQTk5aRjM2QkNPZ21waG5xRGFMZjdtTjNFelVLN3FtTy9hK0ZCNy9zTG1hV2Y0VmMiLCJtYWMiOiIyYTMzNDE5NDkwZDgxYzdjOWMzZjQxODVhYmQ3M2IxMThkMDAwNzdjNmU1NTQ0NDIwNTc5Y2M5ZTI1MTBiNDJjIiwidGFnIjoiIn0%3D'
    };

    var body = {
    'rating': _rating.toInt().toString(),
    'review': descriptioncontroller.text
    };

    var request = http.Request('POST', Uri.parse(url));
    request.bodyFields = {
      'rating': _rating.toInt().toString(),
      'review': descriptioncontroller.text
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);
    print("Review Response"+ jsondata);
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Review',),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/anniversary.png',scale: 2.2,),
                      SizedBox(width: 10,),
                      Text('Order ID : ${orderId}',
                        textAlign: TextAlign.left,style: TextStyle(
                            fontSize: 20,color: Colors.grey,fontWeight: FontWeight.w400
                        ),),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),

                // RatingBarIndicator(
                //   rating: 2.5,
                //   itemBuilder:
                //       (context,
                //       index) =>
                //       Icon(
                //         Icons.star,
                //         color: Colors
                //             .amber,
                //       ),
                //   itemCount: 5,
                //   itemSize: 30.0,
                //   direction: Axis
                //       .horizontal,
                // ),

          RatingBar(
            initialRating: _initialRating,
            direction: _isVertical ? Axis.vertical : Axis.horizontal,
            itemCount: 5,
            ratingWidget: RatingWidget(
              full: Icon(
                Icons.star,
                color: Color(0xffEC1B23),
              ),
              half: Icon(
                Icons.star_half,
                color:Color(0xffEC1B23),
              ),
              empty: Icon(
                Icons.star_border_outlined,
                color:Color(0xffEC1B23),
              ),
            ),
            unratedColor: Colors.grey.withAlpha(50),
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
              print("Rating"+ _rating.toInt().toString());
            },
            updateOnDrag: true,
          ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow:[new BoxShadow(
                      color: Colors.white,
                      blurRadius: 2.0,
                    ),],
                    // border: Border.all(color: Colors.grey,width: 1),
                    // borderRadius: BorderRadius.circular(5)
                  ),


                  child: TextFormField(
                    cursorColor: Colors.grey,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    //textInputAction:,
                    maxLines: 5,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.2,
                    ),
                    decoration: InputDecoration(
                      hintText: "Comment...",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffEC1B23)),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.2,
                      ),
                      contentPadding: EdgeInsets.only(
                          top: 12, bottom:12, left: 8.0, right: 8.0),
                      isDense: true,
                      errorStyle: TextStyle(
                        color: Color(0xffEC1B23),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.2,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffEC1B23)),
                      ),
                    ),
                    controller: descriptioncontroller,

                    // onFieldSubmitted: (value) {
                    //   if (widget.onSubmitField != null) widget.onSubmitField();
                    // },
                    // onTap: () {
                    //   if (widget.onFieldTap != null) widget.onFieldTap();
                    // },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Buttonwithouticon(
                  onpressed: () {
                    submitReview(token);
                }, inputText: 'Submit',)
              ],
            ),
          ),
        ),
      ),
    );
  }


}
