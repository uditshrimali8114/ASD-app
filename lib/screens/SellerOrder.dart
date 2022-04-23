import 'dart:convert';

import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/search_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart'as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class SellerOrderedPage extends StatefulWidget {
  const SellerOrderedPage({Key? key}) : super(key: key);

  @override
  _SellerOrderedPageState createState() => _SellerOrderedPageState();
}

class _SellerOrderedPageState extends State<SellerOrderedPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  GetStorage box = GetStorage();
  var token,reason,numItem;
  List myProd = [];
  List cartList = [];
  // double total_amt=0.0;
  bool loading = true;

  TextEditingController reasonController = TextEditingController();

  Future getData() async {
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });

    getCartProducts(token);
    getMyOrders(token);
  }

  Future<void> getCartProducts(token) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_cart_detail;
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
          loading = false;
          // cartStatus = "false";
        });
      }
      if (jsonData['status'] == "Token is Expired") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("CartDetails Success");
      setState(() {
        loading = false;
        cartList = jsonData['data']['data'];
        numItem = cartList.length;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
      });
      print("cartLen: "+numItem.toString());
    }
    else {
      print("No data Found");
    }
  }

  Future<void> getMyOrders(token) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_my_order;
    var requestUrl = url;
    print("getMyOrders request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(requestUrl), headers: headers);

    print("myProd request url" + requestUrl);
    print("myProd api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("myProd Header" + headers.toString());
    print("myProd response" + jsonData['success'].toString());
    if (response.statusCode == 200) {
      if (jsonData['success'] == false) {
        setState(() {
          loading = false;
          // cartStatus = "false";
        });
      }
      if (jsonData['status'] == "Token is Expired") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("CartDetails Success");
      setState(() {
        loading = false;
        myProd = jsonData['data']['data'];
        // numItem = cartList.length;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
      });
      print("cartLen: "+myProd.toString());
    }
    else {
      print("No data Found");
    }
  }

  Future<void> acceptOrder(token,id) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_accept_order+ id.toString();
    var requestUrl = url;
    print("getMyOrders request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.put(Uri.parse(requestUrl), headers: headers);

    print("Accepted request url" + requestUrl);
    print("Accepted api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Accepted Header" + headers.toString());
    print("Accepted response" + jsonData['success'].toString());
    if (response.statusCode == 200) {
      if (jsonData['success'] == false) {
        setState(() {
          loading = false;
          // cartStatus = "false";
        });
      }
      if (jsonData['status'] == "Token is Expired") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("Accepted Success");
      getData();
      setState(() {
        loading = false;
        // myProd = jsonData['data']['data'];
        // numItem = cartList.length;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
      });
      // print("cartLen: "+myProd.toString());
    }
    else {
      print("No data Found");
    }
  }

  Future<void> cancelOrder(id01,reason) async {

    String url =
        ApiConfig().baseurl + ApiConfig().api_cancel_order + id01.toString();
    var requestUrl = url;
    print("AddtoCart request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };


    var request = http.Request('PUT', Uri.parse(requestUrl));
    request.bodyFields = {
      'reason': reason.toString()
    };

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Order Cancel Successful",

          timeInSecForIosWeb: 7,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
      print("Add to cart "+ jsondata.toString());
      setState(() {
        loading = true;
      });
      if(jsondata['success'].toString()=='false'){
        Fluttertoast.showToast(msg: jsondata['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );

        // Get.to(()=>Cart());
      }
      getData();
      // print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar:  AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: const Text("Seller Order"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(

              color: const Color(0xffEC1B23),
              borderRadius: const BorderRadius.only(bottomLeft: const Radius.circular(25))
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // scaffoldKey.currentState?.openDrawer();
          },
          icon: GestureDetector(
            onTap: (){
              Get.offAll(()=>bottomBar(bottom:0));
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
                GestureDetector(
                    onTap:(){
                      Get.to(()=>SearchPage());
                      setState(() {
                        // flag = true;
                      });
                    },
                    child: Container(child: Image.asset('assets/images/search.png',scale: 3,))),
                const SizedBox(width: 20,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const Cart()));
                  },
                  child: Stack(
                    children: <Widget>[
                      Image.asset('assets/images/cart.png',scale: 3,),
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
                                  color: const Color(0xffFFC960)
                              ),
                              child: Text(
                                numItem == null
                                    ? "0"
                                    : numItem.toString(),
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
                const SizedBox(width: 10,),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: myProd.length,
                itemBuilder: (BuildContext context, int index){
              return  Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/anniversary.png',scale: 3,),
                                  SizedBox(width: 7,),
                                  Container(
                                      width: size.width*0.5,
                                      child: Text('Order ID : ${myProd[index]['order_number']}',style: TextStyle(color: Colors.grey,fontSize: 14),)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/order.png',scale: 1.5,),
                                  SizedBox(width: 7,),
                                  Text('Order Date :${myProd[index]['order_date']}',
                                    style: TextStyle(color: Colors.grey,fontSize: 14),),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10,top: 10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              myProd[index]['order_status']==0?
                              GestureDetector(
                                onTap:(){
                                  // cancelOrder(token,myProd[index]['id']);


                                  showDialog(context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          // backgroundColor: Color(0xFFe81818),
                                          content: Container(
                                            height: height*.50,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              //Rockstar
                                              children: [
                                                TextFormField(
                                                  controller: reasonController,
                                                  keyboardType: TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintText: "Cancellation reason",
                                                  ),
                                                ),

                                                FlatButton(
                                                  onPressed: (){
                                                    setState(() {
                                                      reason = reasonController.text;
                                                    });
                                                    cancelOrder(myProd[index]['id'],reason);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel product",style: TextStyle(color: Colors.white),),
                                                  color:Color(0xffEC1B23),

                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                  );

                                },
                                child: Container(
                                  width: size.width*0.2,
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Color(0xffEC1B23),width: 1)
                                  ),
                                  child: Text("Cancel",textAlign: TextAlign.center,style: TextStyle(color: Color(0xffEC1B23),fontSize: 12),),
                                ),
                              ):Container(
                                width: size.width*0.2,
                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: Color(0xffEC1B23),width: 1)
                                ),
                                child: Text("Message",textAlign: TextAlign.center,style: TextStyle(color: Color(0xffEC1B23),fontSize: 12),),
                              ),
                              SizedBox(height: 10,),
                              myProd[index]['order_status']==0?
                              GestureDetector(
                                onTap: (){
                                  acceptOrder(token,myProd[index]['id']);
                                },
                                child: Container(
                                  width: size.width*0.2,
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.green,width: 1)
                                  ),
                                  child: Text("Accept", textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.green,fontSize: 12),),
                                ),
                              ): Container(
                                width: size.width*0.2,
                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: Colors.green,width: 1)
                                ),
                                child: myProd[index]['order_status']==1?
                                Text("Accepted", textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green,fontSize: 12),):myProd[index]['order_status']==2?Text("Cancelled", textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green,fontSize: 12),): Text("Deliverd", textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green,fontSize: 12),),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height:60,
                            width: 60,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle
                            ),
                            child: Image.network(myProd[index]['product_name'][0]['product_images'],scale: 1.5,)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${myProd[index]['product_name'][0]['product_name']}",
                              style: TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Text("Qty : ${myProd[index]['quantity']}",
                              style: TextStyle(fontSize: 14,color: Colors.grey,),),
                            SizedBox(height: 5,),
                            Text("Price : \$${myProd[index]['amount']}",
                              style: TextStyle(fontSize: 14,color: Colors.grey,),),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              );
            }
            ),
          ),

        ],
      ),
    );
  }
}
