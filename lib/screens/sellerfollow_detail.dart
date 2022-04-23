
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


class sellerfollower extends StatefulWidget {
  const sellerfollower({Key? key}) : super(key: key);

  @override
  _sellerfollowerPageState createState() => _sellerfollowerPageState();
}

class _sellerfollowerPageState extends State<sellerfollower> {
  bool login= false;
  bool flag = false;
  var size,height,width,token;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List followingList = [];
  List followersList = [];
  GetStorage box = GetStorage();

  Future getData() async{
    var savedValue = box.read('token');
    setState(() {
      // flag = true;
      token = savedValue;
    });
    getFollowingData(token);
    getFollowersData(token);
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
        loading = false;
      });

    }else{
      print("No data Found");
    }
  }

  Future<void> getFollowersData(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_followers;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("Followers request url" + requestUrl);
    print("Followers api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("FollowersHeader" + headers.toString());
    print("Followersresponse" + jsonData.toString());
    if (response.statusCode == 200) {
      print("Followers Success");
      var data = jsonData['data']['data'];
      setState(() {
        loading = false;
        followersList = data;
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          title: Text("Followers"),
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
          bottom: TabBar(
            isScrollable: false,
            indicatorWeight: 2,
            tabs: [
              Container(
                  child: Tab(
                    text: "Followers",
                  )),
              Container(
                  child: Tab(
                    text: "Following",
                  )),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
          ),
        ),
        body:TabBarView(
          children: [
            loading== false?
            Container(
              color: Colors.white,
              child: followers(size),
            ):Center(
              child: Container(

                  child: CircularProgressIndicator()),
            ),

            // second tab bar viiew widget
            loading== false?Container(
              color: Colors.white,
              child: following(size),
            ):Center(
              child: Container(

                  child: CircularProgressIndicator()),
            ),
          ],
        )
      ),
    );
  }

  Widget followers(Size size) {
    return  Center(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: followersList.length,
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
                      child:followersList[index]['profile_image']==null?
                      Image.asset('assets/images/profileimg.png'):
                      ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(followersList[index]['profile_image'])),
                    ),
                    // CircleAvatar(
                    //   radius: 35.0,
                    //   backgroundImage: AssetImage('assets/images/addidas.png'),
                    //   // backgroundImage:NetworkImage(profilepic),
                    // ),
                    title: Container(
                      // padding: const EdgeInsets.only(top:10),
                        child: Text('${followersList[index]['name']}',style:const TextStyle(fontSize: 16),)),
                    subtitle:followersList[index]['user_type']==1?
                    Text("Buyer",style:const TextStyle(fontSize: 14)):
                    Text("Seller",style:const TextStyle(fontSize: 14)),
                    isThreeLine: true,
                  ),
                ),
              ),
            );
          }),
    );
  }


  Widget following(Size size) {
    return  Center(
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
    );
  }

}
