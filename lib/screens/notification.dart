import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool flag = false;
  bool loading = true;
  List cartList = [];
  List notiList = [];
  var numItem, size, height, width, token;
  GetStorage box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    // getcategories(token);
    getCartProducts(token);
    getNotificationData(token);
  }

  Future<void> getCartProducts(token) async {
    String url = ApiConfig().baseurl + ApiConfig().api_cart_detail;
    var requestUrl = url;
    print("CartDetails request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(requestUrl), headers: headers);

    print("CartDetails request url" + requestUrl);
    print("CartDetails api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("CartDetailsHeader" + headers.toString());
    print("CartDetailsresponse" + jsonData['success'].toString());
    if (response.statusCode == 200) {
      if (jsonData['success'] == false) {
        setState(() {
          // loading = false;
          // cartStatus = "false";
        });
      }
      if (jsonData['status'] == "Token is Expired") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("CartDetails Success");
      setState(() {
        // loading = false;
        cartList = jsonData['data']['data'];
        numItem = cartList.length;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
      });
      print("cartLen: " + numItem.toString());
    } else {
      print("No data Found");
    }
  }

  Future<void> getNotificationData(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_notification;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("Notification request url" + requestUrl);
    print("Notification api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());
    print("response" + jsonData.toString());
    if (response.statusCode == 200) {
      if(jsonData['success']==false){
        setState(() {
          loading=false;
        });
      }
      print("Success");


      setState(() {
        notiList = jsonData['data']['data'];
        loading = false;
      });

    }else{
      print("No data Found");
    }
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: const Text("Notification"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: const Color(0xffEC1B23),
              borderRadius: const BorderRadius.only(
                  bottomLeft: const Radius.circular(25))),
        ),
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: GestureDetector(
            onTap: () {
              Get.offAll(() => bottomBar(bottom: 0));
            },
            child: Image.asset(
              'assets/images/back.png',
              height: 20,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const Cart()));
                  },
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/cart.png',
                        scale: 3,
                      ),
                      // const Icon(Icons.brightness_1,
                      //     size: 20.0, color: Colors.white70),
                      Positioned(
                          top: 3.0,
                          // right: 6.0,
                          left: 5,
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: const Color(0xffFFC960)),
                              child: Text(
                                numItem == null ? "0" : numItem.toString(),
                                style: const TextStyle(
                                    color: Color(0xffEC1B23),
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
      body: loading==true?Center(
        child: Container(
            margin: const EdgeInsets.only(top: 100),
            child: const CircularProgressIndicator()),
      ):notiList.length==0?Center(
        child: Container(
          child: Text('No Data Found'),
        ),
      ):Column(
        children: [
          Expanded(
            flex: 1, child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: notiList.length,
              // itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Container(
                    height: 80,
                    width: width*0.8,

                    child: Row(
                      children: [
                        index%2==0?
                        Container(
                          height: 70,
                          width: 70,
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            // color: Color(0xFF708090),
                            borderRadius: BorderRadius.circular(35),
                              border: Border.all(color: Color(0xFF708090),width: 3 )
                          ),
                          child: Image.asset('assets/images/bell.png',color: Color(0xffEC1B23),),
                        ):
                        Container(
                          height: 70,
                          width: 70,
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              // color: Color(0xffEC1B23),
                              borderRadius: BorderRadius.circular(35),
                            border: Border.all(color: Color(0xffEC1B23),width: 3 )
                          ),
                          child: Image.asset('assets/images/bell.png',color: Color(0xFF708090),),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10,left: 15),
                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 20,
                                width: width*0.65,
                                child: Text("Title: ${notiList[index]['title']}",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                height: 35,
                                width: width*0.65,
                                child: Text("Message: ${notiList[index]['message']}",maxLines: 3,overflow: TextOverflow.ellipsis,),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                  ),
                );
              }),
          ),
        ],
      ),
    );
  }
}
