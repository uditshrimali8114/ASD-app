
import 'dart:convert';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/search_page.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:asd/custombutton/Buttonwithouticon.dart';
import 'package:asd/screens/PlanPayment.dart';
import 'package:flutter/material.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {


  GetStorage box = GetStorage();
  var size,height,width,numItem;
  var token,amt,duration,limit,CurrentPage;
  bool loading = true;
  List Plans = [];
  List cartList = [];

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
    getPlansData(token);
    getCartProducts(token);
  }


  Future<void> getPlansData(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_plans;
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
      var empId= jsonData['data']['data'];
      var curPage = jsonData['data']['current_page'];
      print("plans"+empId[0]['amount'].toString());
      print("plans"+curPage.toString());

      setState(() {
        Plans = empId;
        amt = empId[0]['amount'];
        duration = empId[0]['duration'];
        limit = empId[0]['limit'];
        CurrentPage = curPage;
        loading=false;
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

// var size, height, width,numItem;
  bool flag = false;

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
        title: const Text("Plans"),
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
        child: CircularProgressIndicator(),
      ):SingleChildScrollView(
        child: Plans.length==0? Container(
          margin: EdgeInsets.only(top: 50),
          child: Text("No Plans Found"),
        ):Container(
          padding: EdgeInsets.all(18),
          height: height*0.7,
          width: width,
          child: ListView.builder(

              scrollDirection: Axis.horizontal,
              itemCount: Plans.length, itemBuilder: (context, index) {
            return Card(
              elevation: 15,
              child: Container(
                // height: height*0.7,
                padding: EdgeInsets.only(left: 10,right: 10),
                width: width*0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child:  Container(
                        height: 168,
                        width: 168,
                        // padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffec1b23),
                            boxShadow: [new BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),],
                            border: Border.all(color: Color(0xfff58c90).withOpacity(1),width: 15)

                        ),
                        child: Text("\$${Plans[index]['amount']}",textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 60,color: Colors.white,fontWeight: FontWeight.w700),),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/circle_check.png'),
                          SizedBox(width: 10,),
                          Text('Product Upload Limit: ${Plans[index]['limit']}',style: TextStyle(fontSize: 18,color: Colors.grey),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/circle_check.png'),
                          SizedBox(width: 10,),
                          Text('Time Duration Days ${Plans[index]['duration']}',style: TextStyle(fontSize: 18,color: Colors.grey),),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Buttonwithouticon(inputText: "Pay \$${Plans[index]['amount']}",
                        onpressed: (){
                     Get.to(PlanPaymentPage(),arguments:[Plans[index]['id'],Plans[index]['name'],Plans[index]['amount']] );
                    })
                  ],
                ),
              ),
            );}
          ),
        ),
      ),
    );
  }
}
