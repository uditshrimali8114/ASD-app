
import 'dart:convert';
import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:asd/Appbar/HomeAppbar.dart';
import 'package:asd/screens/product_details.dart';
import 'package:asd/screens/search_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/CustomWidget/seller_withbutton.dart';
import 'package:asd/HomePageWidgets/category_widget.dart';
import 'package:asd/HomePageWidgets/productcard.dart';
import 'package:asd/HomePageWidgets/sallers_tile.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/product_screen.dart';
// import 'package:asd/customproductdetail/productcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'chat_details.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({Key? key}) : super(key: key);

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {

  refresh(){
    setState(() {

    });
  }

  var size, height, width,token,_pageSize,lastPage;
  var isFollowed;
  bool loading = true;
  bool flag = false;
  List SellerData = [];
  List SellerId= [];
  List SellerProducts= [];
  GetStorage box = GetStorage();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    getData();
    // getProfileData();
  }

  Future getData() async{
    var savedValue = box.read('token');
    setState(() {
      SellerData.clear();
      _pageSize = 1;
      token = savedValue;
      getAllSeller(token);
    });


  }


  Future<void> getAllSeller(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_getAll_seller_page+_pageSize.toString()+"&&limit=3";
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("allSeller request url" + requestUrl);
    print("allSeller api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("allSellerHeader" + headers.toString());
    print("allSellerresponse" + jsonData['status'].toString());
    if (response.statusCode == 200) {
      if(jsonData['status']=="Token is Expired"){
        box.remove('is_login');
        Get.offAll(()=>const LoginPage());
      }
      if(jsonData['success']==true)
        {
          print("allSellerSuccess");
          //var sellData= jsonData['data']['data'];
         var las= jsonData['data']['last_page'];

          //print("abc"+sellData.toString());

          setState(() {

            loading = false;
            lastPage = jsonData['data']['last_page'];
            // lastPage = las;
            SellerData.addAll(jsonData['data']['data']);
            // Fluttertoast.showToast(msg: SellerData.length.toString());

            //SellerId = [];
          });
          // for (int i =0 ; i<SellerData.length;i++){
          //
          //   SellerId.add(SellerData[i]['id']);
          //   //print("sellerIds: "+ SellerId.toString());
          //   // getAllSellerProducts(token,SellerData[i]['id']);
          // }
          //print("sellerIds: "+ SellerId.toString());
          //print('SellerData=>'+SellerData.toString());
        }

    }else{
      print("No data Found");
    }
  }

  Future<void> follow_unfollow(sellerid) async {

    String url =
        ApiConfig().baseurl + ApiConfig().api_follow_seller + sellerid.toString();
    var requestUrl = url;
    print("userFollow request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.post(Uri.parse(requestUrl), headers: headers);

    print("userFollow request url" + requestUrl);
    print("userFollow api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("userFollow Header" + headers.toString());
    // print("ProductDetailresponse" + jsonData['data'][0].toString());
    if (response.statusCode == 200) {
      if (jsonData['status'] == "Token is Expired") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("userFollow Success");
      // var sellprod= jsonData['data'][0];

      // print("abc"+sellData.toString());
      SellerData.clear();
      getData();

      // if(isFollowed==true){
      //   setState(() {
      //     isFollowed=false;
      //   });
      // }else if(isFollowed==false){
      //   setState(() {
      //     isFollowed=true;
      //   });
      // }
      // setState(() {
      //   // SellerData.clear();
      //   // getData();
      //   loading = false;
      //   // proDetail.add(sellprod) ;
      // });
      // print('categories' + proDetail.toString());
    } else {
      print("No data Found");
    }
  }

  // Future<void> getAllSellerProducts(token,idProd) async {
  //
  //   String url = ApiConfig().baseurl + ApiConfig().api_product_seller+"1"+"&seller_id="+idProd.toString()+"&limit=5";
  //   // String url = "https://technolite.in/staging/asdadmin/"+ "api/products/seller?page=&seller_id=5&limit=";
  //   //print("sellerIDS"+url.toString());
  //   var requestUrl = url;
  //
  //   var headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //     'Authorization': 'Bearer $token'
  //
  //   };
  //
  //
  //   var response =
  //   await http.get(Uri.parse(requestUrl), headers: headers);
  //
  //   var jsonData = jsonDecode(response.body);
  //
  //   if (response.statusCode == 200) {
  //     if(jsonData['status']=="Token is Expired"){
  //       box.remove('is_login');
  //       Get.offAll(()=>const LoginPage());
  //     }
  //     if(jsonData['success']==true)
  //       {
  //         var sellprod= jsonData['data']['data'];
  //
  //         // print("abc"+sellData.toString());
  //
  //         setState(() {
  //           loading = false;
  //           print("dataOn Id $idProd"+sellprod.toString());
  //           SellerProducts.add(sellprod);
  //           // if(jsonData['data']==null){
  //           //   print("dataOn Id $idProd is null");
  //           //   SellerProducts.add([]);
  //           // }
  //           // else{
  //           //   print("dataOn Id $idProd"+sellprod.toString());
  //           //   SellerProducts.add(sellprod);
  //           // }
  //
  //           // SellerProducts=sellprod;
  //
  //         });
  //       }
  //
  //     else{
  //       print("udit $idProd");
  //     }
  //     print("sellerProduct Success");
  //
  //     print('productsArray'+SellerProducts.toString());
  //     // if(jsonData['success']==true){
  //     //   print("sellerProduct Success");
  //     //   var sellprod= jsonData['data']['data'];
  //     //
  //     //   // print("abc"+sellData.toString());
  //     //
  //     //   setState(() {
  //     //     loading = false;
  //     //     SellerProducts.add(sellprod);
  //     //     // SellerProducts=sellprod;
  //     //
  //     //   });
  //     //   print('productsArray'+SellerProducts.toString());
  //     //
  //     // }
  //
  //   }else{
  //     print("No data Found");
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;


    return  Scaffold(
      // backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar:flag==false?
      AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Text("Seller"),
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
                    onTap: (){
                      Get.to(Cart());
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
      body: loading==true?
      Center(
        child:  const CircularProgressIndicator(),
      )
          :
      Column(
        children: [
          Expanded(
            flex: 1,
            child: NotificationListener<ScrollNotification>(
              onNotification:
                  (ScrollNotification scrollNotification) {
                if (!loading &&
                    (scrollNotification
                        .metrics.maxScrollExtent -
                        scrollNotification
                            .metrics.pixels)
                        .round() <=
                        200) {
                  if (lastPage>=_pageSize){
                    print("pagenumber"+_pageSize.toString());
                    _pageSize++;
                    getAllSeller(token);
                  }else {}

                  setState(() {
                    loading = false;
                  });
                }
                return true;
              },

              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: SellerData.length, itemBuilder: (context, index) {
                return Column(

                    children:[

                      // ?Sellers
                      ListTile(
                        leading: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffECECEC),
                          ),
                          child: SellerData[index]['profile_image'] ==null?
                          Image.asset('assets/images/profileimg.png',):
                          Image.network(SellerData[index]['profile_image']),
                        ),
                        title: Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('${SellerData[index]['bussness_name']}',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                              ],
                            )),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${SellerData[index]['total_products']} Products",style:TextStyle(fontSize: 16)),
                            Row(
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
                                    color: Color(0xFFc01211),
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                Text("(${SellerData[index]['total_rating']})",style: TextStyle(fontSize: 10),)
                              ],
                            )
                          ],
                        ),
                        isThreeLine: true,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SellerData[index]['follower']==true?
                            Container(
                              width: width*0.45,
                              child: FlatButton(
                                child:  const Text('Unfollow', style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                color: const Color(0xFFe81818),
                                textColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    //SellerProducts.clear();
                                    //_pageSize=1;
                                     follow_unfollow(SellerData[index]['id']);
                                    //follow_unfollow("");
                                  });

                                },
                                // {
                                //   Navigator.push(
                                //       context, MaterialPageRoute(builder: (context) => Dashboard()));
                                // },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)
                                ),
                              ),
                            ):
                            Container(
                              width: width*0.45,
                              child: FlatButton(
                                child:  const Text('Follow', style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                color: const Color(0xFFe81818),
                                textColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    //SellerData.clear();
                                    //_pageSize = 1;
                                    //follow_unfollow("");
                                     follow_unfollow(SellerData[index]['id']);
                                  });


                                },
                                // {
                                //   Navigator.push(
                                //       context, MaterialPageRoute(builder: (context) => Dashboard()));
                                // },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)
                                ),
                              ),
                            ),
                            Container(
                              width: width*0.45,
                              child: FlatButton(
                                // height: height*0.06,
                                child:  const Text('Message', style: TextStyle(fontSize: 18.0),),
                                color: const Color(0xFFfbd8d6),
                                textColor: const Color(0xFFe81818),
                                onPressed: () {
                                  Get.to(()=>ChatDetails(),arguments: [SellerData[index]['id'],SellerData[index]['profile_image'],SellerData[index]['name']]);
                                },
                                // {
                                //   Navigator.push(
                                //       context, MaterialPageRoute(builder: (context) => Dashboard()));
                                // },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                      // Products
                      SizedBox(
                        height: 10,
                      ),
                      SellerData[index]['products'].length==0?Container():Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: SellerData[index]['products'].length, itemBuilder: (context, Index) {
                          return SellerData[index]['products'].length==0?Container(): Container(
                            // height: 250,
                              width: width*0.55,
                              decoration: BoxDecoration(
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(()=>const ProductDetails(), arguments: SellerData[index]['products'][Index]['id']);
                                },
                                child: Card(
                                  margin:  EdgeInsets.only(left: 5,right: 5),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        height: 100,
                                        child: Image.network(SellerData[index]['products'][Index]['product_images'],
                                          alignment: Alignment.center,),
                                      ),
                                      Row(
                                        children: [
                                          Container(margin: EdgeInsets.only(left: 10),
                                              child: Image.asset('assets/images/like.png')),
                                          Container(margin: EdgeInsets.only(left: 10),
                                              child: Text("${SellerData[index]['products'][Index]['total_likes']} likes",style: TextStyle(color: Color(0xffC1C1C1))))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width:width*0.5,
                                            margin: EdgeInsets.only(top: 10,left: 5),
                                            child: Text("${SellerData[index]['products'][Index]['product_name']}",maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),

                                ),
                              )
                          );}
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]
                );}
              ),
            ),
          ),
        ],
      ),

    );
  }
}
