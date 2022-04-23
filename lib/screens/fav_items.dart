import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/aftercart_address.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/product_details.dart';
import 'package:asd/screens/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteItems extends StatefulWidget {
  const FavoriteItems({Key? key}) : super(key: key);

  @override
  _FavoriteItemsState createState() => _FavoriteItemsState();
}

class _FavoriteItemsState extends State<FavoriteItems> {
  refresh() {
    setState(() {});
  }

  // [ id, pic , businessName , totalProduct, rating]
  void initState() {
    super.initState();

    getData();
    // getProfileData();
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
    request.bodyFields = {'quantity': '1'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);

    if (response.statusCode == 200) {
      print("Add to cart " + jsondata.toString());
      if (jsondata['success'].toString() == 'true') {
        Fluttertoast.showToast(
            msg: jsondata['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);

        Get.to(() => AddressPage());
      }
      // print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
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
    request.bodyFields = {'quantity': '1'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);

    if (response.statusCode == 200) {
      print("Add to cart " + jsondata.toString());
      if (jsondata['success'].toString() == 'true') {
        Fluttertoast.showToast(
            msg: jsondata['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);
        getCartProducts(token);
        // Get.to(()=>Cart());
      }
      // print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  List cartList = [];
  List SellerProducts = [];
  var isFollowed, sellerid;
  var _pageSize, lastPage;
  GetStorage box = GetStorage();
  var token, numItem;
  bool loading = true;

  Future getData() async {
    var savedValue = box.read('token');
    // var ab = prevPage[5].toString();
    setState(() {
      _pageSize = 1;
      token = savedValue;
      // isFollowed = ab;
    });
    getAllLikedProducts(token);
    getCartProducts(token);
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

  Future<void> getAllLikedProducts(token) async {
    String url = ApiConfig().baseurl +
        ApiConfig().api_liked_paging +
        _pageSize.toString() +
        "&limit=5";
    // String url = "https://technolite.in/staging/asdadmin/"+ "api/products/seller?page=&seller_id=5&limit=";
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(requestUrl), headers: headers);

    print("sellerProduct request url" + requestUrl);
    print("sellerProduct api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("sellerProductHeader" + headers.toString());
    print("sellerProductresponse" + jsonData['status'].toString());
    if (response.statusCode == 200) {
      if (jsonData['status'] == "Token is Expired") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("sellerProduct Success");
      var sellprod = jsonData['data']['data'];
      var las = jsonData['data']['last_page'];
      // print("abc"+sellData.toString());

      setState(() {
        SellerProducts.addAll(sellprod);
        lastPage = las;
        loading = false;
      });
      print('categories' + SellerProducts.toString());
    } else {
      print("No data Found");
    }
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool flag = false;
  var size, height, width;

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
              title: const Text("Favorite items"),
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
                      GestureDetector(
                          onTap: () {
                            Get.to(() => SearchPage());
                            setState(() {
                              // flag = true;
                            });
                          },
                          child: Container(
                              child: Image.asset(
                            'assets/images/search.png',
                            scale: 3,
                          ))),
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
                      const SizedBox(
                        width: 10,
                      ),
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
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white),
                child: Row(
                  children: [
                    Container(
                      width: width * 0.62,
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
                    Image.asset(
                      'assets/images/search.png',
                      scale: 3,
                      color: const Color(0xFF708090),
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
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: loading == true
            ? Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: const CircularProgressIndicator()),
              )
            : Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollNotification) {
                        if (!loading &&
                            (scrollNotification.metrics.maxScrollExtent -
                                        scrollNotification.metrics.pixels)
                                    .round() <=
                                200) {
                          if (lastPage >= _pageSize) {
                            print("pagenumber" + _pageSize.toString());
                            _pageSize++;
                            getAllLikedProducts(token);
                          }

                          setState(() {
                            loading = false;
                          });
                        }
                        return true;
                      },
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: SellerProducts.length,
                          // itemCount: 1,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 10,
                              margin: const EdgeInsets.all(15),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const ProductDetails(),
                                          arguments: SellerProducts[index]
                                              ['id']);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      // height: 120,s
                                      height: height * 0.38,
                                      child: SellerProducts[index]
                                                  ['product_images'] ==
                                              null
                                          ? Image.asset(
                                              'assets/images/product01.png',
                                              alignment: Alignment.center,
                                            )
                                          : Image.network(SellerProducts[index]
                                              ['product_images']),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:width*0.45,
                                          margin: const EdgeInsets.fromLTRB(
                                              15, 7, 0, 5),
                                          child: Text(
                                            SellerProducts[index]
                                                ['product_name'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              12, 7, 12, 10),
                                          child: Text(
                                            "\$${SellerProducts[index]['actual_price']}",
                                            style: const TextStyle(
                                                color: Color(0xff708090),
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: width * .4,
                                        margin: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 5),
                                        child: Text(
                                          "${SellerProducts[index]['description']}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: const Color(0xff708090),
                                              fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        height: 25,
                                        // width:60,

                                        child: FlatButton(
                                          onPressed: () {
                                            showBottomSheet(
                                                // elevation: 5,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height: 300,
                                                    color: Colors.transparent,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .grey,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft:
                                                                      const Radius
                                                                              .circular(
                                                                          40),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          40))),
                                                      child: Center(
                                                        child: Column(
                                                          // mainAxisAlignment: MainAxisAlignment.center,
                                                          // mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 15),
                                                              height: 5,
                                                              width: 40,
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xffC4C4C4),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    border: Border.all(
                                                                        width:
                                                                            4,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                              13),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                120,
                                                                            child:
                                                                                Image.network(
                                                                              SellerProducts[index]['product_images'],
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          )),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        SellerProducts[index]
                                                                            [
                                                                            'product_name'],
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Container(
                                                                      width: size
                                                                              .width *
                                                                          0.5,
                                                                      child:
                                                                          Text(
                                                                        SellerProducts[index]
                                                                            [
                                                                            'description'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        FlatButton(
                                                                          onPressed:
                                                                              () {},
                                                                          child:
                                                                              Text(
                                                                            "\$${SellerProducts[index]['selling_price']}",
                                                                            style:
                                                                                const TextStyle(color: Colors.white),
                                                                          ),
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                                          color:
                                                                              const Color(0xFFe81818),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              size.width * 0.5,
                                                                          child:
                                                                              Text(
                                                                            "\$${SellerProducts[index]['actual_price']}",
                                                                            style: const TextStyle(
                                                                                color: Color(0xff708090),
                                                                                fontSize: 16,
                                                                                decoration: TextDecoration.lineThrough),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 50,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    // Get.to(()=>EditAddressPage());
                                                                    // Get.to(()=>Cart());
                                                                    BuyNow(SellerProducts[
                                                                            index]
                                                                        ['id']);
                                                                  },
                                                                  child: Container(
                                                                      height:
                                                                          40,
                                                                      width:
                                                                          width *
                                                                              0.4,
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffe81818),
                                                                          borderRadius: BorderRadius.circular(
                                                                              5)),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          "Buy Now",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color(0xffffffff)))),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    AddToCart(SellerProducts[
                                                                            index]
                                                                        ['id']);
                                                                  },
                                                                  child: Container(
                                                                      height:
                                                                          40,
                                                                      width:
                                                                          width *
                                                                              0.4,
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Color(
                                                                                  0xffe81818),
                                                                              width:
                                                                                  0.5),
                                                                          borderRadius: BorderRadius.circular(
                                                                              5)),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          "Add Item",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color(0xffe81818)))),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Text(
                                            "\$${SellerProducts[index]['selling_price']}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          color: const Color(0xFFe81818),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
// Column(
//
// children:[
// ListTile(
// leading: Container(
// width: 100,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// color: Color(0xffECECEC),
// ),
// child:prevPage[1]==null? Image.asset('assets/images/addidas.png',):Image.network(prevPage[1]),
// ),
// title: Container(
// margin: EdgeInsets.only(top: 15),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('${prevPage[2]}',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
// // Text("See All", style: TextStyle(fontSize: 14, color: Color(0xFFc01211)),),
// ],
// )),
// subtitle: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text("${prevPage[3]} Products",style:TextStyle(fontSize: 16)),
// Row(
// children: [
// RatingBar.builder(
// initialRating: 3,
// minRating: 1,
// direction: Axis.horizontal,
// allowHalfRating: true,
// itemCount: 5,
// itemSize: 15,
// itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
// itemBuilder: (context, _) => Icon(
// Icons.star,
// color: Color(0xFFc01211),
// ),
// onRatingUpdate: (rating) {
// print(rating);
// },
// ),
// Text("(${prevPage[4]})",style: TextStyle(fontSize: 10),)
// ],
// )
// ],
// ),
// isThreeLine: true,
// ),
// Container(
// margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// isFollowed=='true'?
// Container(
// width: width*0.45,
// child: FlatButton(
// child:  Text('Unfollow', style: TextStyle(fontSize: 18.0,color: Colors.white),),
// color: Color(0xFFe81818),
// textColor: Colors.white,
// onPressed: () {
// follow_unfollow(sellerid);
// },
// // {
// //   Navigator.push(
// //       context, MaterialPageRoute(builder: (context) => Dashboard()));
// // },
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(3)
// ),
// ),
// ):
// Container(
// width: width*0.45,
// child: FlatButton(
// child:  Text('Follow', style: TextStyle(fontSize: 18.0,color: Colors.white),),
// color: Color(0xFFe81818),
// textColor: Colors.white,
// onPressed: () {
// follow_unfollow(sellerid);
// },
// // {
// //   Navigator.push(
// //       context, MaterialPageRoute(builder: (context) => Dashboard()));
// // },
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(3)
// ),
// ),
// ),
// Container(
// width: width*0.45,
// child: FlatButton(
// // height: height*0.06,
// child:  Text('Message', style: TextStyle(fontSize: 18.0),),
// color: Color(0xFFfbd8d6),
// textColor: Color(0xFFe81818),
// onPressed: () {},
// // {
// //   Navigator.push(
// //       context, MaterialPageRoute(builder: (context) => Dashboard()));
// // },
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(3)
// ),
// ),
// ),
//
// ],
// ),
// )
// ]
// ),
