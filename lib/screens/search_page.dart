// import 'dart:html';
import 'dart:convert';

import 'package:asd/screens/login.dart';
import 'package:asd/screens/product_details.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool flag = true;
  var numItem,size,height,width,token;
  bool loading = true;
  GetStorage box = GetStorage();
  List cartList = [];
  List searchList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    // getcategories(token);
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
      print("cartLen: " + numItem.toString());
    } else {
      print("No data Found");
    }
  }

  Future<void> SearchProds(token) async {
    String url = ApiConfig().baseurl + ApiConfig().api_search+searchController.text;
    var requestUrl = url;
    print("CartDetails request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
      'Cookie': 'XSRF-TOKEN=eyJpdiI6ImZwWCt2dEZmTElUQjkrTXdTQ2kzSFE9PSIsInZhbHVlIjoiTk5TRjRrcnA2VitJMHdBQi9PSWVJWTFJM1dNeXR4NzM1VHozVXhIUWNNTmswcFB2WTVlTWpLcDE4VXRUa0tBVlRBTnZzWHMvQjhDcHJpdjBDU1dneTd6U2F5cHV3emJ1Y2EwOVpsL3gxRGJRK2J2V3NjY08xbmVYcFVoK3hZaXYiLCJtYWMiOiIyODc4OWU2MWY5N2VjOGE2Y2NlMGJmMTE3NjZkM2EyOGIwZDRmMTliYmRkOTMzMjM2MzZjNTE1M2VlYWUyMjRmIiwidGFnIjoiIn0%3D; asd_session=eyJpdiI6InpQWkxGUVVRcHVuOUhUR1FldTk3RVE9PSIsInZhbHVlIjoiOW1iS3VFN2VxdGh1U2lxWVlkS0JkclpPdEVjMWl2STdxQmVNd1pDR3gzNmdVMU5UOGxOb091MXlONUtya1VPNjBwK25rTTAxTVVBOVVTOXY2WVdjUEdRS2FnVlVabUgwVnVYd1pvanhKajJISjRGZk1wczRFTlZKNEtWN0c5d1EiLCJtYWMiOiJmNzNhYWExNTUzMjJhYzY5NjNhYzE0NDNhODVjYzhkNjdiZTUzOWU0YThlNzBlN2EyYzQ2NDJlZTE2ZDRmYjJiIiwidGFnIjoiIn0%3D'
    };
    var request = http.Request('GET', Uri.parse(requestUrl));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);

    print("+++++" + jsondata.toString());

    if (response.statusCode == 200) {
      if (jsondata['success'] == true){
        print("Success"+jsondata['data']['data'].toString());

        setState(() {
          searchList = jsondata['data']['data'];
        });
      }else{
        setState(() {
          searchList =[];
        });
      }

    }
    else {
      print("failed"+jsondata);
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
        title: const Text("Search Result"),
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
                        flag = true;
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
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Search Product",
                  ),
                ),
              ),
              GestureDetector(
                  onTap: (){
                    SearchProds(token);
                  },
                  child: Image.asset('assets/images/search.png',scale: 3,color: const Color(0xFF708090),))
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
        child:searchList.length==0?Text("No Data Found!!",style: TextStyle(fontSize: 18),):
        Column(
          children: [
            Expanded(
              flex: 1, child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: searchList.length,
                // itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Get.to(()=>const ProductDetails(), arguments: searchList[index]['id']);
                    },
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: Container(
                        height: 80,
                        width: width*0.8,

                        child: Row(
                          children: [

                            Container(
                              height: 70,
                              width: 70,
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                // color: Color(0xFF708090),
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(color: Color(0xFF708090),width: 3 )
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.network(searchList[index]['product_images'])),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 10,left: 15),
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 20,
                                    width: width*0.65,
                                    child: Text("Product Name: ${searchList[index]['product_name']}",style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  Container(
                                    height: 35,
                                    width: width*0.65,
                                    child: Text("Price: ${searchList[index]['selling_price']}",maxLines: 3,overflow: TextOverflow.ellipsis,),
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
          ],
        ),
      ),
    );
  }
}
