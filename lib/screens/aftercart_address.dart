
import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/screens/OrderPlaced.dart';
import 'package:asd/screens/editaddress.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/search_page.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/custombutton/Buttonwithouticon.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:asd/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool flag= false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GetStorage box = GetStorage();
  var token,cartStatus,address01,address02,pincode,landmark,itemCount;
  bool loading = true;
  List cartList = [];
  double total_amt=0.0;
  double selling_price=0.0;
  double delivery_charge=0.0;



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
      print("Success");
      var empId= jsonData['data']['id'];
      String add1= jsonData['data']['address_1'];
      String add2= jsonData['data']['address_2'];
      String landm= jsonData['data']['landmark'];
      String pinc= jsonData['data']['pincode'];
      var propic= jsonData['data']['profile_image'];
      var whtsup= jsonData['data']['whatsapp'];
      var user_type= jsonData['data']['user_type'];
      // String add= jsonData['data']['address'];
      // String comId= jsonData['data']['company_id'];

      setState(() {
        address01 = add1;
        address02 = add2;
        landmark = landm;
        pincode = pinc;
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
      if(jsonData['success']==false){
        setState(() {

          cartStatus = "false";
        });

      }
      if (jsonData['status'] == "Token is Expired") {

        box.remove('is_login');
        Get.offAll(() => LoginPage());
      }
      print("CartDetails Success");
      setState(() {
        loading = false;
        cartList = jsonData['data']['data'];
        itemCount = cartList.length;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        cartStatus = jsonData['success'];
      });


      print("object"+cartList.toString());
      for (int i = 0; i<cartList.length;i++){
        setState(() {
          total_amt = total_amt + double.parse(cartList[i]['amount']) ;
          selling_price = selling_price + double.parse(cartList[i]['selling_price']) ;
          delivery_charge = delivery_charge + double.parse(cartList[i]['delivery_charge']) ;
        });

        print("total_amt ${i}th "+ total_amt.toString());
      }


      // print('cartList`=> '+isLikedList.toString());
    } else {
      print("No data Found");
    }
  }

  Future<void> PurchaseProduct(token) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_purchase_prod+"0&paypal_response=null";
    var requestUrl = url;
    print("CartDetails request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('POST', Uri.parse(requestUrl));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Get.to(()=>OrderPlacedPage());

    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> PurchaseProductPaypal(token,response01) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_purchase_prod+"1&paypal_response="+response01.toString();
    var requestUrl = url;
    print("CartDetails request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('POST', Uri.parse(requestUrl));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Get.to(()=>OrderPlacedPage());

    }
    else {
      print(response.reasonPhrase);
    }

  }

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
        title: Text("Address"),
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
      body: SingleChildScrollView(
        child:loading == true
            ? Center(
          child: Container(
              margin: EdgeInsets.only(top: 100),
              child: CircularProgressIndicator()),
        )
            : Container(
          // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                        ),
                        child: Text("Address")),

                    Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                        ),
                        child:  Text("Payment")),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,

                        ),
                        child: Icon(Icons.circle, color: Color(0xffEC1B23),size: 15,)),
                    Container(
                        width: size.width*0.70,
                        child:Row(
                          children: List.generate(
                              100 ~/ 2,
                                  (index) => Expanded(
                                child: Container(
                                  color: index % 2 == 0
                                      ? Colors.transparent
                                      : Colors.redAccent,
                                  height: 1,
                                ),
                              )),
                        )

                    ),


                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,

                        ),
                        child: Icon(Icons.circle, color: Color(0xff626262),size: 15,)),
                  ],
                ),
              ),

              SizedBox(height: 15,),
              
              Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(15),
                height: height*0.14,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/billing.png"),
                            Text("Billing Address",style: TextStyle(color: Color(0xff626262),fontSize: 16),),
                          ],
                        ),
                        GestureDetector(
                            onTap: (){
                              Get.to(()=>EditAddressPage());
                            },
                            child: Image.asset("assets/images/editadd.png"))
                      ],
                    ),
                    address01==null?
                    Container( margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                    child: Text("Please Edit Address Before Checkout"),)
                        :Container(
                      margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text("$address01 , $address02 , Near $landmark, Pin Code $pincode", style: TextStyle(color: Color(0xff626262),fontSize: 16),)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.topLeft,
                  child: Text("Order Summary", style: TextStyle(fontSize: 18,color: Color(0xff626262),fontWeight: FontWeight.bold),)),

              Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                  color: Color(0xffEC1B23),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width:width*0.28,
                          child: Text("Product name",style: TextStyle(color: Colors.white,fontSize: 16),)),
                      Container(
                          width:width*0.1,
                          child: Text("Qty.",style: TextStyle(color: Colors.white,fontSize: 16),)),
                      Container(
                          width:width*0.12,
                          child: Text("Price",style: TextStyle(color: Colors.white,fontSize: 16),)),
                      Container(
                          width:width*0.18,
                          child: Text("SubTotal",style: TextStyle(color: Colors.white,fontSize: 16),)),

                    ],
                  ) ),
              Container(
                height: height*0.25,
                 child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: cartList.length,
                      // itemCount: 1,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            // Get.to(()=>ProductDetails(), arguments: SellerProducts[index]['id']);
                          },
                          child: Container(
                              height: 40,
                              margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                              color: Color(0xffF2F2F2),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width:width*0.28,
                                      child: Text("${cartList[index]['product_name']}",style: TextStyle(color: Color(0xff626262),fontSize: 16),)),
                                  Container(
                                      width:width*0.1,
                                      child: Text("${cartList[index]['quantity']}",style: TextStyle(color: Color(0xff626262),fontSize: 16),)),
                                  Container(
                                      width:width*0.12,
                                      child: Text("${cartList[index]['selling_price']}",style: TextStyle(color: Color(0xff626262),fontSize: 16),)),


                                  Container(
                                      width:width*0.18,
                                      child: Text("${(double.parse(cartList[index]['selling_price'])*double.parse(cartList[index]['quantity'].toString())).toString()}",style: TextStyle(color: Color(0xff626262),fontSize: 16),)),

                                ],
                              ) ),
                        );
                      })
              ),
              Container(
                margin: EdgeInsets.only(right: 15,bottom: 15),
                alignment: Alignment.centerRight,
                child: Text("Net Amount ($itemCount): $selling_price",style: TextStyle(fontSize: 14,color: Colors.grey,),),
              ),

              Container(
                margin: EdgeInsets.only(right: 15,bottom: 15),
                alignment: Alignment.centerRight,
                child: Text("Shipping Charges: $delivery_charge",style: TextStyle(fontSize: 14,color: Color(0xffEC1B23),),),
              ),
              Container(
                margin: EdgeInsets.only(right: 15,bottom: 15),
                alignment: Alignment.centerRight,
                child: Text("Total: $total_amt",style: TextStyle(fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold),),
              ),
              Buttonwithouticon(
                onpressed: () {

                  address01==null? Get.to(()=>EditAddressPage()):address02==null?Get.to(()=>EditAddressPage()):landmark==null?Get.to(()=>EditAddressPage()):pincode==null?Get.to(()=>EditAddressPage()):PurchaseProduct(token);
                  },
                inputText: 'Cash on Delivery',),
              GestureDetector(
                onTap: (){
                  address01==null? Get.to(()=>EditAddressPage()):address02==null?Get.to(()=>EditAddressPage()):landmark==null?Get.to(()=>EditAddressPage()):pincode==null?Get.to(()=>EditAddressPage()):

                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                            "AW33Rb9K6FxrHZmYUgPRAsBIuPCUjEf7e_IXknCzNVy5F_HiPMnTJiKK86Dag3FjK8Y0DCUTIVhV8nae",
                            secretKey:
                            "ENKtA9tZbqLaPhKygBJ9o4MgBla0R-TglrNDFetn5cveiX--Qri7fzLC7D4YcYy85iLGB-kgjslTl6wO",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '0.01',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '0.01',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '0.01',
                                      "currency": "USD"
                                    }
                                  ],

                                  // shipping address is not required though
                                  // "shipping_address": {
                                  //   "recipient_name": "Jane Foster",
                                  //   "line1": "Travis County",
                                  //   "line2": "",
                                  //   "city": "jodhpur",
                                  //   "country_code": "US",
                                  //   "postal_code": "73301",
                                  //   "phone": "+00000000",
                                  //   "state": "Rajasthan"
                                  // },
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              var response01 = params;
                              PurchaseProductPaypal(token,response01);
                              print("objectSuccess" + response01["payerID"]);
                              print("onSuccess: $params");
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                  );
                },
                child: Container(
                    height: 55,
                    margin: EdgeInsets.only(left: 10,right: 10),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1,color: Colors.indigo),
                        borderRadius: BorderRadius.circular(0.5)
                    ),
                    child: Image.asset('assets/images/paypal.png',scale: 2,)
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
