
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';


class buyerfollower extends StatefulWidget {
  const buyerfollower({Key? key}) : super(key: key);

  @override
  _buyerfollowerPageState createState() => _buyerfollowerPageState();
}

class _buyerfollowerPageState extends State<buyerfollower> {
  bool login= false;
  bool loading= true;

  bool flag = false;
  var size,height,width,token;
  List followingList = [];
  GetStorage box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async{
    var savedValue = box.read('token');
    setState(() {
      // flag = true;
      token = savedValue;
    });
    getFollowingData(token);
  }


  Future<void> getFollowingData(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_following;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("Following request url" + requestUrl);
    print("Following api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("FollowingHeader" + headers.toString());
    print("Followingresponse" + jsonData.toString());
    if (response.statusCode == 200) {
      print("Following Success");
      var data = jsonData['data']['data'];
      setState(() {
        followingList = data;
      });

    }else{
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
        title: Text("Following"),
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
      body: Center(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: followingList.length,
            itemBuilder: (context, index) {
              return Container(
                // height: 80,
                alignment: Alignment.center,
                // width:width*0.6,
                child: GestureDetector(
                  onTap: (){
                    // Get.to(()=>const ProductScreen(),arguments:[SellerData[index]['id'],SellerData[index]['profile_image'],SellerData[index]['bussness_name'],SellerData[index]['total_products'],SellerData[index]['total_rating'],SellerData[index]['follower']]);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Container(
                        // margin: EdgeInsets.only(bottom: 15),
                        // height: 150,
                        width: 55,
                        decoration:  BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey,width: 3),
                          color: Colors.orange,
                        ),
                        child:followingList[index]['profile_image']==null?
                        Image.asset('assets/images/profileimg.png'):
                        ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(followingList[index]['profile_image'])),
                      ),
                      // CircleAvatar(
                      //   radius: 35.0,
                      //   backgroundImage: AssetImage('assets/images/addidas.png'),
                      //   // backgroundImage:NetworkImage(profilepic),
                      // ),
                      title: Container(
                        // padding: const EdgeInsets.only(top:10),
                          child: Text('${followingList[index]['name']}',style:const TextStyle(fontSize: 16),)),
                      subtitle:followingList[index]['user_type']==1?
                      Text("Buyer",style:const TextStyle(fontSize: 14)):
                      Text("Seller",style:const TextStyle(fontSize: 14)),
                      isThreeLine: true,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

}
