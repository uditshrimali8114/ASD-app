
import 'dart:convert';
import 'package:asd/screens/change_password.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart'as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/AddProduct.dart';
import 'package:asd/screens/OrderPlaced.dart';
import 'package:asd/screens/Orderhistory.dart';
import 'package:asd/screens/PlanPayment.dart';
import 'package:asd/screens/Planpage.dart';
import 'package:asd/screens/ReviewPage.dart';
import 'package:asd/screens/SellerOrder.dart';
import 'package:asd/screens/SellerProduct.dart';
import 'package:asd/screens/SellerProfile.dart';
import 'package:asd/screens/forgotpassword.dart';
import 'package:asd/screens/home.dart';
import 'package:asd/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class sidedrawer extends StatefulWidget {
  const sidedrawer({Key? key}) : super(key: key);

  @override
  _sidedrawerstate createState() => _sidedrawerstate();
}

class _sidedrawerstate extends State<sidedrawer> {

  GetStorage box = GetStorage();
  var token,name,userName,email,mobileNum,profilePic,whatsapp,userType;
  bool loading = true;



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
    getProfileData(token);
  }


  Future<void> Logout(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_logout;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("Logout" + requestUrl);
    print("Logout" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());
    print("response Logout" + jsonData['status'].toString());
    if (response.statusCode == 200) {
      if(jsonData['status']=="Token is Expired"){
        box.remove('is_login');

      }
      print("Success");
      Get.offAll(()=>LoginPage());
      // var empId= jsonData['data']['data'];

      // print("abc"+empId.toString());

      setState(() {

      });

    }else{
      print("No data Found");
    }
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
      print("Success");
      var empId= jsonData['data']['id'];
      String firname01= jsonData['data']['name'];
      String username= jsonData['data']['username'];
      String email01= jsonData['data']['email'];
      String mobile= jsonData['data']['mobile'];
      var propic= jsonData['data']['profile_image'];
      var user_type= jsonData['data']['user_type'];
      // String whtsup= jsonData['data']['whatsapp'];
      // String add= jsonData['data']['address'];
      // String comId= jsonData['data']['company_id'];

      setState(() {
        name = firname01;
        userName = username;
        email = email01;
        mobileNum = mobile;
        profilePic = propic;
        userType = user_type;
        loading = false;
      });

    }else{
      print("No data Found");
    }
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Container(
      child: SafeArea(
        child: Container(
          width: size.width * 0.76,


          child: Drawer(
            child: ListView(
              children: [
                Container(
                  //width: 240,
                 // height: size.height * 0.3,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  color: Color(0xffEC1B23),
                  child: loading==true?Center(
                    child: CircularProgressIndicator(),
                  ):Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          shape: BoxShape.circle,

                        ),
                        child: Container(
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
                        )
                        //padding: EdgeInsets.all(5),
                      ),
                      Container(
                       width: size.width*0.8,
                        //padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),

                        child: Text(
                          '$name',
                          textAlign: TextAlign.center,style: TextStyle(
                              fontSize: 15, color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  color: Colors.white,



                  child: Column(
                    children: [

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomePage()));
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Home",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          var Bottom= 2;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>bottomBar(bottom: Bottom)));
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Profile",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => PlanPage()));
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Plans",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      userType== 2 ?
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AddProductPage()));
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Add Product",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ):Container(),
                      userType== 2 ?
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>SellerProductPage());
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("My Product",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ):Container(),
                      userType== 2 ?
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>SellerOrderedPage());

                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("My Order",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ):Container(),
                      GestureDetector(
                        onTap: (){

                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Live",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.offAll(()=>bottomBar(bottom: 1));
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => SellerProductPage()));
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Message",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                        Get.offAll(()=>bottomBar(bottom: 4));
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Notification",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          var Bottom= 3;
                          Get.offAll(()=>bottomBar(bottom: Bottom));
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) =>bottomBar(bottom: Bottom)));
                          },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Order History",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>ChangePassword());
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => ChangePassword()));
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15,top: 10),
                              child: Text("Change Password",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  width: size.width*0.3,
                                  // padding: EdgeInsets.,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffEC1B23),
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                                Container(
                                  width: size.width*0.46,
                                  // padding: EdgeInsets.fromLTRB(5,15,0,15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.4
                                      ),
                                    ),

                                  ),
                                  child:Text("",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: ()=>Logout(token),

                        child: Container(
                          width: size.width*0.5,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xffEC1B23),
                            shape: BoxShape.rectangle
                          ),
                          child: Text("Logout",textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: 20,),









                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
