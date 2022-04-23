
import 'dart:async';
import 'dart:convert';
import 'package:asd/screens/ReviewPage.dart';
import 'package:asd/screens/chat_details.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/search_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {

  _refresh(){

  }

  TextEditingController reasonController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  var _formKey = GlobalKey<FormState>();
  GetStorage box = GetStorage();
  var token,reason;
  List orderHist = [];
  List cartList = [];
  // double total_amt=0.0;
  bool loading = true;

  Future getData() async {
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    getOrderHistory(token);
    getCartProducts(token);
  }


  Future<void> getOrderHistory(token) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_order_history;
    var requestUrl = url;
    print("CartDetails request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(requestUrl), headers: headers);

    print("OrderHistory request url" + requestUrl);
    print("OrderHistory api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("OrderHistoryHeader" + headers.toString());
    // print("OrderHistoryresponse" + jsonData['success'].toString());
    if (response.statusCode == 200) {
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      if(jsonData['success']==false){
        setState(() {
          loading = false;
          // cartStatus = "false";
        });

      }
      if (jsonData['status'] == "Token is Expired") {

        box.remove('is_login');
        Get.offAll(() => LoginPage());
      }

      var odrHis = jsonData['data'];
      print("OrderHistory Success");
      setState(() {

        orderHist = odrHis;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
        loading = false;
      });
      // for (int i = 0; i<cartList.length;i++){
      //   isLikedList.add(cartList[i]['user_like']);
      // }
      // for (int i = 0; i<cartList.length;i++){
      //   setState(() {
      //     total_amt = total_amt + double.parse(cartList[i]['amount']) ;
      //   });
      //
      //   print("total_amt ${i}th "+ total_amt.toString());
      // }


      // print('cartList`=> '+isLikedList.toString());
    } else {
      print("No data Found");
    }
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
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
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

  bool flag = false;
  var size,height,width,numItem;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar:flag==false?
      AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: const Text("Order History"),
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
      ):
      AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title:Container(
          // alignment: Alignment.center,
          height: 35,
          padding: const EdgeInsets.only(left: 5,right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white
          ),
          child: Row(
            children: [
              Container(
                width: width*0.62,
                child: TextFormField(

                  decoration: const InputDecoration(
                    hintText: "Search Product",

                  ),

                ),
              ),
              Image.asset('assets/images/search.png',scale: 3,color: const Color(0xFF708090),)
            ],
          ),
        ),
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
            setState(() {
              flag = false;
            });
          },
          icon: Image.asset(
            'assets/images/back.png',
            height: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              ],
            ),
          ),
        ],
      ),
      body: loading==true?Center(
        child: Container(
            margin: const EdgeInsets.only(top: 100),
            child: const CircularProgressIndicator()),
      ):Column(
        children: [
          orderHist.length==0?Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Text("No Order History Found"),
            ),
          ):
          Expanded(
            flex: 9,
            child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: orderHist.length,
                // itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      // Get.to(()=>ProductDetails(), arguments: SellerProducts[index]['id']);
                    },
                    child:orderHist[index]['order_status']==0?
                    //    order pending
                    Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Row(
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
                                        child: Text('Order ID : ${orderHist[index]['order_number']}',style: TextStyle(color: Colors.grey,fontSize: 14),)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/order.png',scale: 1.5,),
                                    SizedBox(width: 7,),
                                    Text('Order Date : ${orderHist[index]['order_date']}',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/ordr_cancel.png',scale: 1.5,),
                                    SizedBox(width: 7,),
                                    Text('Delivery Date : deliver within week',style: TextStyle(color: Colors.green,fontSize: 14),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: (){

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
                                                  Form(
                                                    key:_formKey,
                                                    child: TextFormField(
                                                      controller: reasonController,
                                                      keyboardType: TextInputType.text,
                                                      decoration: InputDecoration(
                                                        hintText: "Cancellation reason",
                                                      ),
                                                      onFieldSubmitted: (value) {
                                                        //Validator
                                                      },
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please Enter Reason of Cancellation';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),

                                                  FlatButton(
                                                    onPressed: (){

                                                      final isValid = _formKey.currentState!.validate();
                                                      if (!isValid) {
                                                        return;
                                                      }
                                                      else{
                                                        setState(() {
                                                          reason = reasonController.text;
                                                        });
                                                        cancelOrder(orderHist[index]['id'],reason);
                                                        Navigator.pop(context);
                                                      }


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
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: size.width*0.2,
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.grey,width: 1)
                                  ),
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.to(()=>ChatDetails(),arguments: [orderHist[index]['seller_id'],orderHist[index]['profile_image'],orderHist[index]['name']]);
                                    },
                                    child: Text("Message", textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey,fontSize: 12),),
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ):
                    //    order deliverd Or cancelled
                    orderHist[index]['order_status']==1?Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Row(
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
                                        child: Text('Order ID : ${orderHist[index]['order_number']}',style: TextStyle(color: Colors.grey,fontSize: 14),)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/order.png',scale: 1.5,),
                                    SizedBox(width: 7,),
                                    Text('Order Date : ${orderHist[index]['order_date']}',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/ordr_cancel.png',scale: 1.5,),
                                    SizedBox(width: 7,),
                                    Text('Delivery Date : deliver within week',style: TextStyle(color: Colors.green,fontSize: 14),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: (){

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
                                                      cancelOrder(orderHist[index]['id'],reason);
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
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: size.width*0.2,
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.grey,width: 1)
                                  ),
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.to(()=>ChatDetails(),arguments: [orderHist[index]['seller_id'],orderHist[index]['profile_image'],orderHist[index]['name']]);
                                    },
                                    child: Text("Message", textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey,fontSize: 12),),
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ):
                    Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Row(
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
                                        child: Text('Order ID : ${orderHist[index]['order_number']}',style: TextStyle(color: Colors.grey,fontSize: 14),)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/order.png',scale: 1.5,),
                                    SizedBox(width: 7,),
                                    Text('Order Date : ${orderHist[index]['order_date']}',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/ordr_cancel.png',scale: 1.5,),
                                    SizedBox(width: 7,),
                                    orderHist[index]['order_status']==3?
                                    Text('Delivery Date : ${orderHist[index]['delivery_date']}',style: TextStyle(color: Colors.green,fontSize: 14),):
                                    Text('Cancelled Date : ${orderHist[index]['cancel_date']}',style: TextStyle(color: Color(0xffEC1B23),fontSize: 14),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                orderHist[index]['order_status']==3?
                                Container(
                                  width: size.width*0.2,
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.green,width: 1)
                                  ),
                                  child: Text("Delivered",textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontSize: 12),),
                                ):
                                Container(
                                  width: size.width*0.2,
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color:  Color(0xffEC1B23),width: 1)
                                  ),
                                  child: Text("Cancelled",textAlign: TextAlign.center,style: TextStyle(color:  Color(0xffEC1B23),fontSize: 12),),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: size.width*0.2,
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.grey,width: 1)
                                  ),
                                  child:orderHist[index]['order_status']==3?
                                  GestureDetector(
                                    onTap: (){
                                      Get.to(()=>ReviewPage(),arguments: [orderHist[index]['id'],orderHist[index]['order_number']]);
                                      // ReviewPage()
                                    },
                                    child: Text("Review", textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey,fontSize: 12),),
                                  )
                                      :GestureDetector(
                                    onTap: (){
                                      Get.to(()=>ChatDetails(),arguments: [orderHist[index]['seller_id'],orderHist[index]['profile_image'],orderHist[index]['name']]);
                                    },
                                        child: Text("Message", textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey,fontSize: 12),),
                                      ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    )
                  );
                }),
          ),
        ],
      ),
    );
  }
}
