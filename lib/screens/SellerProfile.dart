
import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/EditSellerProfile.dart';
import 'package:asd/screens/buyerfollower.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/search_page.dart';
import 'package:asd/screens/sellerfollow_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({Key? key}) : super(key: key);

  @override
  _SellerProfilePageState createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {


  GetStorage box = GetStorage();
var token,name,userName,email,mobileNum,profilePic,whatsapp,userType,numfollowing,numFollowers,numProducts,numItem;
bool loading = true;
List cartList = [];

  void initState() {
    super.initState();
    getData();
    // getProfileData();
  }

  Future getData() async{
    var savedValue = box.read('token');
    setState(() {
      // flag = true;
      token = savedValue;
    });
    getProfileData(token);
    getCartProducts(token);
  }


  Future<void> getProfileData(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_getProfile;
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
    print("response" + jsonData.toString());
    if (response.statusCode == 200) {
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("Success");
      var empId= jsonData['data']['id'];
      String firname01= jsonData['data']['name'];
      String username= jsonData['data']['username'];
      String email01= jsonData['data']['email'];
      String mobile= jsonData['data']['mobile'];
      var propic= jsonData['data']['profile_image'];
      var whtsup= jsonData['data']['whatsapp'];
      var user_type= jsonData['data']['user_type'];
      var following= jsonData['data']['followings'];
      var followers= jsonData['data']['followers'];
      var prods= jsonData['data']['product'];
      // String add= jsonData['data']['address'];
      // String comId= jsonData['data']['company_id'];

      setState(() {
        name = firname01;
        userName = username;
        email = email01;
        mobileNum = mobile;
        profilePic = propic;
        whatsapp = whtsup;
        userType = user_type;
        numfollowing = following;
        numFollowers = followers;
        numProducts = prods;
        loading = false;
      });

    }else{
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
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
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

bool flag = false;
var size,height,width;
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
        title: const Text("Seller Profile"),
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
      body: RefreshIndicator(
        onRefresh: ()=>getData(),
        child: SingleChildScrollView(
          child: loading==true?Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
                child: CircularProgressIndicator()),
          ):Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EditSellerProfilePage()));
                        Get.to(()=>EditSellerProfilePage());
                      },
                      child: Container(
                        width: size.width*0.25,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(6.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Color(0xffEC1B23),width: 1),
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xfffbd1d3)
                        ),
                        child: Text("Edit Profile",textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15,color: Color(0xffEC1B23)),),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: size.width*0.3,
                  height: size.height*0.14,

                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child:Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: profilePic == null?
                          DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage('assets/images/profileimg.png'),
                          ):
                          DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: NetworkImage(profilePic),
                          ),
                          border: Border.all(
                            color:Colors.white,
                            // width: 8,
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.01,),
                Text("$name",textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22,color: Colors.grey,fontWeight: FontWeight.bold),),
                SizedBox(height: size.height*0.01,),
                userType== 2 ?
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$numProducts Product",style: TextStyle(fontSize: 16,color: Colors.grey),),
                      Text("|",style: TextStyle(fontSize: 16,color: Colors.grey),),
                      GestureDetector(
                          onTap:(){
                            Get.to(()=>sellerfollower());
                          },
                          child: Text("$numFollowers Followers",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                      Text("|",style: TextStyle(fontSize: 16,color: Colors.grey),),
                      GestureDetector(
                          onTap:(){
                            Get.to(()=>sellerfollower());
                          },
                          child: Text("$numfollowing Following",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                    ],
                  ),
                ):
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(()=>buyerfollower());
                    },
                 child: Text("$numfollowing Following",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                ),


                SizedBox(height: size.height*0.03,),
                Container(
                  width: size.width*0.95,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(5)
                  ),
                    child: Text("$name",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                SizedBox(height: size.height*0.03,),
                Container(
                    width: size.width*0.95,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.grey,width: 1),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text("$userName",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                SizedBox(height: size.height*0.03,),
                Container(
                    width: size.width*0.95,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.grey,width: 1),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text("$email",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                SizedBox(height: size.height*0.03,),
                Container(
                    width: size.width*0.95,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.grey,width: 1),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text("$mobileNum",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                SizedBox(height: size.height*0.03,),
                Container(
                    width: size.width*0.95,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.grey,width: 1),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child:whatsapp==null?Text("Enter What'sApp number",style: TextStyle(fontSize: 16,color: Colors.grey),):
                    Text("$whatsapp",style: TextStyle(fontSize: 16,color: Colors.grey),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
