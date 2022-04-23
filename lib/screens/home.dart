
import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/HomePageWidgets/category_widget.dart';
import 'package:asd/HomePageWidgets/productcard.dart';
import 'package:asd/HomePageWidgets/sallers_tile.dart';
import 'package:asd/SideDrawer/CustomDrawer.dart';
import 'package:asd/screens/aftercart_address.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/fav_items.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/product_details.dart';
import 'package:asd/screens/product_screen.dart';
import 'package:asd/screens/search_page.dart';
import 'package:asd/screens/seller_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
var size,height,width;
bool flag = false;
class _HomePageState extends State<HomePage> {

  var scaffoldKey = GlobalKey<ScaffoldState>();


  GetStorage box = GetStorage();
  var token,name,userName,email,mobileNum,profilePic,whatsapp, numItem;
  bool loading = true;
  List category = [];
  List cartList = [];
  List ItemNum = [1,2,3,4,5];
  List SellerData = [];
  List PopularData = [];
  List
  LikedData = [];
  String dropdownvalue = '1';

  // List of items in our dropdown menu
  var items = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  void initState() {
    super.initState();
    getData();
    // getProfileData();
  }

  Future getData() async{
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    getcategories(token);
    getAllSeller(token);
    getCartProducts(token);
    getAllliked(token);
    getPopular(token);
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
      // {"status":"Token is Invalid"}
    if (jsonData['status']=="Token is Invalid") {
      box.remove('is_login');
      Get.offAll(() => const LoginPage());
    }
      if (jsonData['message']=="User Token Expired") {
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

  Future<void> getcategories(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_categories;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("Profile request url" + requestUrl);
    print("Profile api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());
    print("response" + jsonData['status'].toString());
    if (response.statusCode == 200) {
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      if(jsonData['message']=="User Token Expired"){
        box.remove('is_login');
        Get.offAll(()=>const LoginPage());
      }
      print("Success");
      var empId= jsonData['data']['data'];

      print("abc"+empId.toString());

      setState(() {
        category = empId;
      });
      print('categories'+category.length.toString());

    }else{
      print("No data Found");
    }
  }

  Future<void> getAllSeller(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_getAll_seller+"5";
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
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      if(jsonData['message']=="User Token Expired"){
        box.remove('is_login');
        Get.offAll(()=>const LoginPage());
      }
      print("allSellerSuccess");
      var sellData= jsonData['data']['data'];

      print("abc"+sellData.toString());

      setState(() {
        loading= false;
        SellerData = sellData;
      });
      print('SellerData=>'+SellerData.toString());

    }else{
      print("No data Found");
    }
  }

  Future<void> getAllliked(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_liked_prod;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("allLiked request url" + requestUrl);
    print("allLiked api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("allLikedHeader" + headers.toString());
    print("allLikedresponse" + jsonData.toString());
    if (response.statusCode == 200) {
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      if(jsonData['message']=="User Token Expired"){
        box.remove('is_login');
        Get.offAll(()=>const LoginPage());
      }
      print("allLikedSuccess");
      var sellData= jsonData['data']['data'];

      print("abc"+sellData.toString());

      setState(() {
        LikedData = sellData;
      });
      print('allLiked=>'+SellerData.toString());

    }else{
      print("No data Found");
    }
  }

  Future<void> getPopular(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_popular_product;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("Popular request url" + requestUrl);
    print("Popular api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("PopularHeader" + headers.toString());
    print("Popularresponse" + jsonData['status'].toString());
    if (response.statusCode == 200) {
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      if(jsonData['message']=="User Token Expired"){
        box.remove('is_login');
        Get.offAll(()=>const LoginPage());
      }
      print("Popular Success");
      var popData= jsonData['data']['data'];

      print("Popular"+popData.toString());

      setState(() {
        PopularData = popData;
      });
      print('allLiked=>'+PopularData.toString());

    }else{
      print("No data Found");
    }
  }

  Future<void> Refresh(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_refresh;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.post(Uri.parse(requestUrl), headers: headers);

    print("Refresh" + requestUrl);
    print("Refresh" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());
    print("response Refresh" + jsonData.toString());
    if (response.statusCode == 200) {
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      if(jsonData['message']=="User Token Expired"){
        box.remove('is_login');
        Get.offAll(()=>const LoginPage());
      }
      print("Success");

      var otp = jsonData['data']['access_token'];
      setState(() {
        box.write('token',otp);
      });
      getData();

    }else{
      print("No data Found");
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
      // if (jsonData['status']=="Token is Invalid") {
      //   box.remove('is_login');
      //   Get.offAll(() => const LoginPage());
      // }
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
        title: Image.asset('assets/images/logo.png',scale: 2.5,),
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
          icon: Image.asset(
            'assets/images/menu.png',
            height: 20,
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
      drawer: const sidedrawer(),
      body: RefreshIndicator(
        onRefresh:()=> Refresh(token) ,
        child: SingleChildScrollView(

          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: width,
            // height: height,
            child: Column(

              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                    child: Container(
                       height: MediaQuery.of(context).size.height * 0.17,
                        child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                         itemCount: category.length, itemBuilder: (context, index) {
                          return Container(
                              margin: const EdgeInsets.only(left: 7, right: 5),
                              // height: MediaQuery.of(context).size.height * 0.13,
                              // width: MediaQuery.of(context).size.width * 0.10,
                              decoration: const BoxDecoration(
                              ),
                              child: Column(
                                children: [
                                  Card(
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      padding: const EdgeInsets.all(10),
                                      // 2cdad0 f9b83a 3da8fe a74cff
                                      decoration: const BoxDecoration(
                                        // shape: BoxShape.circle,
                                        // color: Color(0xFF2cdad0),
                                      ),
                                      child:category[index]['image']==null? Image.asset('assets/images/clothes.png',):Image.network(category[index]['image']),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                      width: 80,
                                      height: 35,
                                      child: Text('${category[index]['name']}',textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: false,))

                                ],
                              )
                          );}
                       ),
                    ),),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      const Text("Sellers", style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                      GestureDetector(
                        onTap: (){Get.to(()=>SellerScreen());},
                          child:  const Text("See All", style: TextStyle(fontSize: 14, color: Color(0xFFc01211)),)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: (){
                      // Get.to(SellerScreen());
                      },
                    child: Container(

                      // padding: EdgeInsets.symmetric(horizontal: 12.0, ),
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: SellerData.length,
                          itemBuilder: (context, index) {
                        return Container(
                          // height: 55,
                          width:width*0.6,
                          child: GestureDetector(
                            onTap: (){
                              Get.to(()=>const ProductScreen(),arguments:[SellerData[index]['id'],SellerData[index]['profile_image'],SellerData[index]['bussness_name'],SellerData[index]['total_products'],SellerData[index]['total_rating'],SellerData[index]['follower'],SellerData[index]['name']]);
                            },
                            child: Card(
                              child: ListTile(
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  padding: EdgeInsets.all(3.0),
                                  // margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffECECEC),
                                  ),
                                  child:ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: SellerData[index]['profile_image']==null? Image.asset('assets/images/profileimg.png',):Image.network(SellerData[index]['profile_image'])),
                                ),
                                // CircleAvatar(
                                //   radius: 35.0,
                                //   backgroundImage: AssetImage('assets/images/addidas.png'),
                                //   // backgroundImage:NetworkImage(profilepic),
                                // ),
                                title: Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Text('${SellerData[index]['bussness_name']}',style:const TextStyle(fontSize: 16),)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${SellerData[index]['total_products']} Products",style:const TextStyle(fontSize: 14)),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 10,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Color(0xFFc01211),
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                        Text("(${SellerData[index]['total_rating']})",style: const TextStyle(fontSize: 10),)
                                      ],
                                    )
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            ),
                          ),
                        );
                      }),
                    )),
                const SizedBox(
                  height: 10,
                ),
                LikedData.length==0?
                Container():
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Favorite items", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      GestureDetector(
                          onTap: (){
                            Get.to(()=>FavoriteItems());
                          },
                          child: Text("See All", style: TextStyle(fontSize: 14, color: Color(0xFFc01211)),)),
                    ],
                  ),
                ),
                LikedData.length==0?
                Container():SizedBox(
                  height: 10,
                ),
                LikedData.length==0?
                Container():Container(
                    margin: const EdgeInsets.only(left: 5,),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.32,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: LikedData.length,
                          itemBuilder: (context, index) {
                        return  Container(
                          // height: 250,
                            width: width*0.55,
                            decoration: BoxDecoration(
                            ),
                            child: Card(
                              margin:  EdgeInsets.only(left: 5,right: 5),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Get.to(()=>const ProductDetails(), arguments: LikedData[index]['id']);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      height: 100,
                                      child: Image.network(LikedData[index]['product_images'] ,
                                        alignment: Alignment.center,),
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Container(margin: EdgeInsets.only(left: 10),
                                  //         child: Image.asset('assets/images/like.png')),
                                  //     Container(margin: EdgeInsets.only(left: 10),
                                  //         child: Text("250 likes",style: TextStyle(color: Color(0xffC1C1C1))))
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      Container(
                                        width: width*0.5,
                                        margin: EdgeInsets.only(top: 10,left: 5),
                                        child: Text("${LikedData[index]['product_name']}",maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 10,left: 5),
                                        child: Text("Shipping:\$${LikedData[index]['delivery_charge']}",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xffEC1B23))),
                                      ),
                                    ],
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(margin: EdgeInsets.only(top: 15,left: 5),
                                        child: Text("\$${LikedData[index]['selling_price']}",style:TextStyle(color:Color(0xff708090),fontSize: 18 ),),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: 15,right: 5),
                                          child:FlatButton(
                                            onPressed: (){
                                              AddToCart(LikedData[index]['id']);
                                            },
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
                        );}
                      ),
                    ),),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Popular items", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5,),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.32,
                    child: PopularData.length==0?Text("No Popular data found"):
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: PopularData.length,
                        itemBuilder: (context, index) {
                          return  Container(
                            // height: 250,
                              width: width*0.55,
                              decoration: BoxDecoration(
                              ),
                              child: Card(
                                margin:  EdgeInsets.only(left: 5,right: 5),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Get.to(()=>const ProductDetails(), arguments: PopularData[index]['id']);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 100,
                                        child: Image.network(PopularData[index]['product_images'] ,
                                          alignment: Alignment.center,),
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Container(margin: EdgeInsets.only(left: 10),
                                    //         child: Image.asset('assets/images/like.png')),
                                    //     Container(margin: EdgeInsets.only(left: 10),
                                    //         child: Text("250 likes",style: TextStyle(color: Color(0xffC1C1C1))))
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        Container(
                                          width: width*0.5,
                                          margin: EdgeInsets.only(top: 10,left: 5),
                                          child: Text("${PopularData[index]['product_name']}",maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10,left: 5),
                                          child: Text("Shipping:\$${PopularData[index]['delivery_charge']}",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xffEC1B23))),
                                        ),
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(margin: EdgeInsets.only(top: 15,left: 5),
                                          child: Text("\$${PopularData[index]['selling_price']}",style:TextStyle(color:Color(0xff708090),fontSize: 18 ),),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(top: 15,right: 5),
                                            child:FlatButton(
                                              onPressed: (){
                                                AddToCart(PopularData[index]['id']);
                                              },
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
                          );}
                    ),
                  ),),


              ],
            ),
          ),
        ),
      ),

    );
  }
}
//GestureDetector(
//                     onTap: (){
//                       Get.to(Cart());
//                     },
//                     child: Image.asset('assets/images/cart.png',scale: 3,))