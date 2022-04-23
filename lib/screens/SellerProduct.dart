
import 'dart:convert';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/AddProduct.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/search_page.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class SellerProductPage extends StatefulWidget {
  const SellerProductPage({Key? key}) : super(key: key);

  @override
  _SellerProductPageState createState() => _SellerProductPageState();
}

class _SellerProductPageState extends State<SellerProductPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  var token,prodList;
  bool loading = true;
  List cartList = [];

  GetStorage box = GetStorage();

  Future getData() async {
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    getSellerProducts(token);
    getCartProducts(token);
  }


  Future<void> getSellerProducts(token) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_seller_product;
    var requestUrl = url;
    print("CartDetails request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(requestUrl), headers: headers);

    print("sellerProd request url" + requestUrl);
    print("sellerProd api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("sellerProdHeader" + headers.toString());
    print("sellerProdresponse" + jsonData['success'].toString());
    if (response.statusCode == 200) {
      if(jsonData['success']==false){
        setState(() {
          loading = false;
          // cartStatus = "false";
        });

      }
      if (jsonData['status'] == "Token is Expired") {

        box.remove('is_login');
        // Get.offAll(() => LoginPage());
      }
      print("sellerProd Success");
      setState(() {
        loading = false;
        prodList = jsonData['data']['data'];
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
      });
      // for (int i = 0; i<cartList.length;i++){
      //   isLikedList.add(cartList[i]['user_like']);
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
      print("cartLen: "+numItem.toString());
    }
    else {
      print("No data Found");
    }
  }

  var size,height,width,numItem;
  bool flag = false;
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
        title: const Text("My Products"),
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
      body: Scaffold(
        body:  loading == true
            ? Center(
          child: Container(
              margin: EdgeInsets.only(top: 50),
              child: CircularProgressIndicator()),
        )
            :Column(
          children: [
            prodList==null?Center(
              child: Container(
                  margin: EdgeInsets.only(
                    top: 150
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("No Product Added !"),

                      GestureDetector(
                        onTap: (){
                          Get.off(()=>AddProductPage());
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 25),
                          height: 35,
                          width: width*0.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xffEC1B23),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text("Add a Product",style: TextStyle(color: Colors.white),),
                        ),
                      )

                    ],
                  )),
            ):Expanded(
              child: ListView.builder(
                itemCount: prodList.length,
                  itemBuilder: (BuildContext context, int index){
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding:EdgeInsets.all(7),
                              child: Image.network(prodList[index]['product_images'])),
                          Positioned(
                            top:15,
                            left: size.width*0.8,
                            child: Container(
                              width: 35,
                              height: 35,

                              // decoration: BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   color: Colors.white,
                              //   border: Border.all(color: Colors.black12,width: 1)
                              // ),
                              child: IconButton(onPressed: (){},
                                  icon: Icon(Icons.favorite_border,color: Colors.grey,size: 0,)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(onPressed: (){},
                              icon: Icon(Icons.favorite,color: Colors.grey,size: 25,)),
                          Text(prodList[index]['total_likes'].toString()+" Like",style: TextStyle(fontSize: 12,color: Colors.grey)),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width*0.4,

                                child: Text(prodList[index]['product_name'],style: TextStyle(fontSize: 18))),
                            Container(
                                width: size.width*0.2,
                                child: Text("\$ ${prodList[index]['actual_price']}",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey,fontSize: 14,decoration: TextDecoration.lineThrough),)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    width:200,
                                    child: Text("${prodList[index]['description']}  ",style: TextStyle(fontSize: 18,color: Colors.grey),maxLines: 1,overflow:TextOverflow.ellipsis,)),
                              ],
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xffEC1B23)
                              ),
                              child: Text('\$ ${prodList[index]['selling_price']}',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
