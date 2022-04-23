
import 'dart:async';
import 'dart:convert';

import 'package:asd/screens/chat_details.dart';
import 'package:asd/screens/search_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool login= false;
  bool flag = false;
  bool loading = true;
  var size,height,width,token,numItem;
  List cartList = [];
  List ChatList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  GetStorage box = GetStorage();
  Future getData() async{
    var savedValue = box.read('token');
    // var ab = prevPage[5].toString();
    setState(() {
      // _pageSize = 1;
      token = savedValue;
      // isFollowed = ab;
    });
    // getAllSellerProducts(token);
    getCartProducts(token);
    getMessageWithUser(token);
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

  Future<void> getMessageWithUser(token) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_chat;
    var requestUrl = url;
    print("CartDetails request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(requestUrl), headers: headers);

    print("Chat request url" + requestUrl);
    print("Chat Details api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Chat DetailsHeader" + headers.toString());
    print("Chat Detailsresponse" + jsonData['success'].toString());
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
      print("Chat Details Success");
      setState(() {

        ChatList = jsonData['data'];
        loading = false;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
      });
      print("ChatList: "+ChatList.toString());
    }
    else {
      print("No data Found");
    }
  }

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
        title: const Text("Chat"),
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
      body: loading==true?Center(
        child: Container(
            margin: const EdgeInsets.only(top: 100),
            child: const CircularProgressIndicator()),
      ):RefreshIndicator(
        onRefresh: ()=> getMessageWithUser(token),
        child: Center(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: ChatList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(()=>ChatDetails(),arguments: [ChatList[index]['user_id'],ChatList[index]['profile_image'],ChatList[index]['name']]);
                    },
                    child: Container(
                      height: 80,
                      width: width*0.8,

                      child: Row(
                        children: [
                          index%2==0?
                          Container(
                            height: 70,
                            width: 70,
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              // color: Color(0xFF708090),
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: Color(0xFF708090),width: 3 )
                            ),
                            child:  ChatList[index]['profile_image']==null?
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child:Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: ChatList[index]['profile_image'] == null?
                                    DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage('assets/images/profileimg.png'),
                                    ):
                                    DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: NetworkImage(ChatList[index]['profile_image']),
                                    ),
                                    border: Border.all(
                                      color:Colors.white,
                                      // width: 8,
                                    )
                                ),
                              ),
                            ):
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child:Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image:
                                    DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: NetworkImage(ChatList[index]['profile_image']),
                                    ),
                                    border: Border.all(
                                      color:Colors.white,
                                      // width: 8,
                                    )
                                ),
                              ),
                            ),
                          ):
                          Container(
                            height: 70,
                            width: 70,
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              // color: Color(0xffEC1B23),
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: Color(0xffEC1B23),width: 3 )
                            ),
                            child: ChatList[index]['profile_image']==null?
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child:Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: ChatList[index]['profile_image'] == null?
                                    DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage('assets/images/profileimg.png'),
                                    ):
                                    DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: NetworkImage(ChatList[index]['profile_image']),
                                    ),
                                    border: Border.all(
                                      color:Colors.white,
                                      // width: 8,
                                    )
                                ),
                              ),
                            ):
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child:Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image:
                                    DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: NetworkImage(ChatList[index]['profile_image']),
                                    ),
                                    border: Border.all(
                                      color:Colors.white,
                                      // width: 8,
                                    )
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10,left: 15),
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 20,
                                  width: width*0.65,
                                  child: Text("Name: ${ChatList[index]['name']}",style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  height: 35,
                                  width: width*0.65,
                                  child: Text("Message: ${ChatList[index]['message']}",maxLines: 3,overflow: TextOverflow.ellipsis,),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

}
