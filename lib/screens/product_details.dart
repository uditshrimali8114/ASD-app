import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/CustomWidget/seller_withbutton.dart';
import 'package:asd/HomePageWidgets/sellerscreencard.dart';
import 'package:asd/screens/aftercart_address.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/editaddress.dart';
import 'package:asd/screens/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'login.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var size, height, width;
  bool flag = false;
  bool description = true;
  bool like = true;

  var proId, like001,total_like,numItem;
  List proDetail = [];
  List review = [];
  List cartList = [];
  GetStorage box = GetStorage();
  var token;
  bool loading = true;

  void initState() {
    super.initState();
    proId = Get.arguments;
    getData();

    // getProfileData();
  }

  Future getData() async {
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    getCartProducts(token);
    getProductDetail(token);

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
      print("cartLen: "+numItem.toString());
    }
    else {
      print("No data Found");
    }
  }

  Future<void> getProductDetail(token) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_product_Detail + proId.toString();
    var requestUrl = url;
    print("ProductDetail request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(requestUrl), headers: headers);

    print("ProductDetail request url" + requestUrl);
    print("ProductDetail api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("ProductDetailHeader" + headers.toString());
    print("ProductDetailresponse" + jsonData['data'][0].toString());
    if (response.statusCode == 200) {
      if (jsonData['status'] == "Token is Expired") {
        box.remove('is_login');
        Get.offAll(() => LoginPage());
      }
      print("ProductDetail Success");
      var sellprod = jsonData['data'][0];

      // print("abc"+sellData.toString());

      setState(() {

        proDetail.add(sellprod);
        like001 = jsonData['data'][0]['user_like'];
        total_like = jsonData['data'][0]['total_likes'];
        review = jsonData['data'][0]['reviews'];
        loading = false;
      });
      print('Like=> ' + like001.toString());
    } else {
      print("No data Found");
    }
  }

  Future<void> like_unlike(proId) async {
    print("Prod");
    String url =
        ApiConfig().baseurl + ApiConfig().api_product_like + proId.toString();
    var requestUrl = url;
    print("ProductDetail request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.post(Uri.parse(requestUrl), headers: headers);

    print("ProductDetail request url" + requestUrl);
    print("ProductDetail api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("ProductDetailHeader" + headers.toString());
    // print("ProductDetailresponse" + jsonData['data'][0].toString());
    if (response.statusCode == 200) {
      if (jsonData['status'] == "Token is Expired") {
        box.remove('is_login');
        Get.offAll(() => LoginPage());
      }
      print("ProductDetail Success");
      // var sellprod= jsonData['data'][0];

      // print("abc"+sellData.toString());
      getProductDetail(token);
      setState(() {
        getData();
        loading = false;
        // proDetail.add(sellprod) ;
      });
      print('categories' + proDetail.toString());
    } else {
      print("No data Found");
    }
  }

  Future<void> AddToCart(proId) async {

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
      'quantity': '1'
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

  Future<void> BuyNow(proId) async {

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
      'quantity': '1'
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

        Get.to(()=>AddressPage());
      }
      // print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: flag == false
          ? AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Text("Products Details"),
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
                                  color: Color(0xffFFC960)
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
      )
          : AppBar(
              toolbarHeight: 70,
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
              title: Container(
                // alignment: Alignment.center,
                height: 35,
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white),
                child: Row(
                  children: [
                    Container(
                      width: width * 0.62,
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
                    Image.asset(
                      'assets/images/search.png',
                      scale: 3,
                      color: Color(0xFF708090),
                    )
                  ],
                ),
              ),
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
                    children: [],
                  ),
                ),
              ],
            ),
      body: loading == true
          ? Center(
              child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator()),
            )
          : Column(
              children: [
                Expanded(
                    flex: 9,
                    child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: ImageSlideshow(
                        width: width,
                        height: height * 0.38,
                        initialPage: 0,
                        indicatorColor: Color(0xFFe81818),
                        indicatorBackgroundColor: Color(0xffC4C4C4),
                        children: [
                          Image.network(
                            proDetail[0]['product_images'],
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            proDetail[0]['product_images'],
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            proDetail[0]['product_images'],
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            proDetail[0]['product_images'],
                            fit: BoxFit.cover,
                          ),
                        ],

                        /// Called whenever the page in the center of the viewport changes.
                        onPageChanged: (value) {
                          // print('Page changed: $value');
                        },
                        // autoPlayInterval: 3000,
                        // isLoop: true,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${proDetail[0]['product_name']}",
                          style:
                          TextStyle(fontSize: 20, color: Color(0xff464646)),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 15),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "\$${proDetail[0]['actual_price']}",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 20,
                              color: Color(0xff708090)),
                        )),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 15),
                          height: 30,
                          // width:60,

                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              "\$${proDetail[0]['selling_price']}",
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            color: Color(0xFFe81818),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15, left: 15),
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Color(0xff708090)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/like.png'),
                                Text("${total_like} Likes",
                                    style: TextStyle(color: Color(0xff708090))),
                              ],
                            )),
                        SizedBox(
                          width: width * 0.25,
                        ),
                        GestureDetector(
                          onTap: () {
                            like_unlike(proId);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 15, left: 15),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Color(0xff708090)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: like001 == true
                                ? Image.asset(
                              'assets/images/redlike.png',
                              height: 15,
                            )
                                : Image.asset('assets/images/like.png'),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 15),
                      child: Row(
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
                              color: Color(0xFFe81818),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Text(
                                "(10 Reviews)",
                                style: TextStyle(fontSize: 10),
                              ))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              description = true;
                            });
                          },
                          child: description == true
                              ? Container(
                            margin: EdgeInsets.only(top: 15, left: 15),
                            padding: EdgeInsets.only(left: 7, right: 7),
                            alignment: Alignment.center,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Color(0xFFe81818),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "Description",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                              : Container(
                              margin: EdgeInsets.only(top: 15, left: 15),
                              padding: EdgeInsets.only(left: 7, right: 7),
                              height: 30,
                              alignment: Alignment.center,
                              child: Text("Description",
                                  style:
                                  TextStyle(color: Color(0xff708090)))),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              description = false;
                            });
                          },
                          child: description == true
                              ? Container(
                              margin: EdgeInsets.only(top: 15, left: 15),
                              padding: EdgeInsets.only(left: 7, right: 7),
                              height: 30,
                              alignment: Alignment.center,
                              child: Text("Review (${review.length})",
                                  style: TextStyle(color: Color(0xff708090))))
                              : Container(
                            margin: EdgeInsets.only(top: 15, left: 15),
                            padding: EdgeInsets.only(left: 7, right: 7),
                            alignment: Alignment.center,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Color(0xFFe81818),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "Review (${review.length})",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    description == true
                        ? Container(
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        alignment: Alignment.centerLeft,
                        child: Text("${proDetail[0]['description']}",
                            style: TextStyle(color: Color(0xff708090))))
                        : Container(
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        alignment: Alignment.center,
                        child: review.length == 0?
                        Text("No Review Found !",style: TextStyle(color: Color(0xff708090))):Text("Review")),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
              Expanded(
                flex: 1,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      // Get.to(()=>EditAddressPage());
                      // Get.to(()=>Cart());
                      BuyNow(proId);
                    },
                    child: Container(
                        color: Color(0xffe81818),
                        height: 60,
                        width: width * 0.5,
                        alignment: Alignment.center,
                        child: Text("Buy Now",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffffff)))),
                  ),
                  GestureDetector(
                    onTap: (){
                      AddToCart(proId);
                    },
                    child: Container(
                        height: 60,
                        width: width * 0.5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffe81818), width: 0.5)),
                        alignment: Alignment.center,
                        child: Text("Add Item",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffe81818)))),
                  ),
                ],
              ),),



              ],
            ),
    );
  }
}
