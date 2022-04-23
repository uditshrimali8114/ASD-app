
import 'dart:async';
import 'dart:convert';

import 'package:asd/screens/OrderPlaced.dart';
import 'package:asd/screens/Orderhistory.dart';
import 'package:asd/screens/aftercart_address.dart';
import 'package:asd/screens/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/home.dart';
import 'package:asd/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  // bool login= false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  GetStorage box = GetStorage();
  var token,cartStatus;
  double total_amt=0.0;
  bool loading = true;
  List cartList = [];
  List isLikedList = [];

  Future getData() async {
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    getCartProducts(token);
  }


  Future<void> getCartProducts(token) async {
    setState(() {
      total_amt = 0.0;
    });
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
      if(jsonData['success']==false){
        setState(() {
          loading = false;
          cartStatus = "false";
        });

      }
      if (jsonData['status'] == "Token is Expired") {

        box.remove('is_login');
        Get.offAll(() => LoginPage());
      }
      print("CartDetails Success");
      setState(() {
        loading = false;
        cartList = jsonData['data']['data'];
        // isLiked = jsonData['data']['data'][0]['user_like'];
        cartStatus = jsonData['success'];
      });
      for (int i = 0; i<cartList.length;i++){
        isLikedList.add(cartList[i]['user_like']);
      }
      for (int i = 0; i<cartList.length;i++){
        setState(() {
          total_amt = total_amt + double.parse(cartList[i]['amount']) ;
        });

        print("total_amt ${i}th "+ total_amt.toString());
      }


      print('cartList`=> '+isLikedList.toString());
    } else {
      print("No data Found");
    }
  }

  Future<void> RemoveCart(id01) async {

    String url =
        ApiConfig().baseurl + ApiConfig().api_remove_cart + id01.toString();
    var requestUrl = url;
    print("AddtoCart request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var request = http.Request('DELETE', Uri.parse(requestUrl));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);

    if (response.statusCode == 200) {
      print("Add to cart "+ jsondata.toString());
      setState(() {
        total_amt = 0.0;
      });
      if(jsondata['success'].toString()=='false'){
        Fluttertoast.showToast(msg: jsondata['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        getData();
        // Get.to(()=>Cart());
      }
      // print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> itemCount(count,proId) async {

    String url =
        ApiConfig().baseurl + ApiConfig().api_add_to_cart + proId.toString();
    var requestUrl = url;
    print("AddtoCart request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var request = http.Request('POST', Uri.parse(requestUrl));
    request.bodyFields = {
      'quantity': count.toString()
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);

    if (response.statusCode == 200) {
      print("Add to cart "+ jsondata.toString());
      if(jsondata['success'].toString()=='true'){
        Fluttertoast.showToast(msg: jsondata['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        getCartProducts(token);
        // Get.to(()=>Cart());
      }
      // print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      appBar: flag==false?
      AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Text("Cart"),
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
            scaffoldKey.currentState?.openDrawer();
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
                    onTap: (){
                      // Get.to(Cart());
                    },
                    child: Image.asset('assets/images/cart.png',scale: 3,)),
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
          padding: EdgeInsets.only(left: 5,right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white
          ),
          child: Row(
            children: [
              Container(
                width: width*0.62,
                child: TextFormField(

                  decoration: InputDecoration(
                    hintText: "Search Product",

                    // suffixIcon: IconButton(
                    //     icon: Icon(Icons.search ,
                    //       color: Color(0xFF708090),
                    //     ),
                    //     onPressed: () {
                    //
                    //     }),
                  ),
                ),
              ),
              Image.asset('assets/images/search.png',scale: 3,color: Color(0xFF708090),)
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
      body: SingleChildScrollView(
        child: loading == true
            ? Center(
          child: Container(
              margin: EdgeInsets.only(top: 100),
              child: CircularProgressIndicator()),
        )
            :cartStatus=='false'?
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: Text("No Item in Cart"),
          ),
        ):Column(
          children: [
            Container(
              // padding: EdgeInsets.only(bottom: 100),
              height: height*0.78,
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: cartList.length,
                  // itemCount: 1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        // Get.to(()=>ProductDetails(), arguments: SellerProducts[index]['id']);
                      },
                      child: Card(
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: height*0.15,
                              width: width*0.3,
                              child: cartList[index]['product_images']==null?
                        Image.asset('assets/images/shoes.jpg'):Image.network(cartList[index]['product_images']),
                            ),
                            Container(
                              height: height*0.15,
                              width: width*0.6,
                              // color: Colors.orange,
                              margin: EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: width*.6,
                                          child: Text(cartList[index]['product_name'],style: TextStyle(fontSize: 15,color: Color(0xff708090)),)),
                                    ],
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                          child: Text("\$${cartList[index]['selling_price']}",style: TextStyle(fontSize: 16,color: Color(0xff708090),fontWeight: FontWeight.bold),)),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text("\$${cartList[index]['actual_price']}",style: TextStyle( decoration: TextDecoration.lineThrough,fontSize: 15,color: Color(0xff708090)),)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black12),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                if(cartList[index]['quantity']<=1){
                                                  print("if Part");
                                                  showDialog(context: context,
                                                      builder: (context)
                                                  {
                                                    return AlertDialog(
                                                      // backgroundColor: Color(0xFFe81818),
                                                      content: Container(
                                                        height: height * .3,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          //Rockstar
                                                          children: [
                                                            Text(
                                                                "Do you want to remove product from cart ?"),

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                FlatButton(
                                                                  onPressed: () {
                                                                    setState(() {

                                                                    });
                                                                    RemoveCart(cartList[index]['id']);
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                    "Yes",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),),
                                                                  color: Color(
                                                                      0xffEC1B23),

                                                                ),
                                                                FlatButton(
                                                                  onPressed: () {
                                                                    setState(() {

                                                                    });
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                    "No",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),),
                                                                  color: Color(
                                                                      0xffEC1B23),

                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                }else{
                                                  print("Else Part");
                                                  itemCount(cartList[index]['quantity']-1,cartList[index]['product_id']);
                                                }

                                              },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                    height: 25,
                                                    width:30,
                                                    child: Text('-',style: TextStyle(fontSize: 20,color: Color(0xffc4c4c4),fontWeight: FontWeight.bold),))),
                                            Text('${cartList[index]['quantity']}',style: TextStyle(fontSize: 16,color: Color(0xffEE4036))),
                                            GestureDetector(
                                              onTap: (){
                                                itemCount(cartList[index]['quantity']+1,cartList[index]['product_id']);
                                              },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                    height: 25,
                                                    width:30,
                                                    child: Text('+',style: TextStyle(fontSize: 20,color: Color(0xffc4c4c4),fontWeight: FontWeight.bold)))),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          RemoveCart(cartList[index]['id']);
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Image.asset('assets/images/delete.png',scale: 0.5,),
                                              Text('Remove',style: TextStyle(fontSize: 16,color: Color(0xffc4c4c4)),),

                                            ],
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   height: 30,
                                      //   width: 30,
                                      //   decoration: BoxDecoration(
                                      //       border: Border.all(color: Colors.black12),
                                      //       borderRadius: BorderRadius.circular(5)
                                      //   ),
                                      //   child:cartList[index]['user_like']== false? Image.asset(
                                      //     'assets/images/like.png',
                                      //     height: 15,
                                      //   )
                                      //       : Image.asset('assets/images/redlike.png',),
                                      // ),
                                    ],
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
            GestureDetector(
              onTap: (){
                Get.to(()=> AddressPage());
              },
              child: Container(
                height: height*.10,
                width: width*.97,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:Color(0xffEC1B23),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight:Radius.circular(15) )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin:EdgeInsets.only(left: 10),
                        child: Text("Total (${cartList.length} Items)   \$$total_amt",style: TextStyle(color: Colors.white,fontSize: 16),)),

                    Container(
                        margin:EdgeInsets.only(right: 10),
                        child: Text("Confirm",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
                  ],
                ),

              ),
            )
          ],
        ),
      ),
    );
  }

}
