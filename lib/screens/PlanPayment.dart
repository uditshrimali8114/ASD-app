
import 'dart:convert';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/home.dart';
import 'package:asd/screens/search_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:asd/screens/AddProduct.dart';
import 'package:asd/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PlanPaymentPage extends StatefulWidget {
  const PlanPaymentPage({Key? key}) : super(key: key);

  @override
  _PlanPaymentPageState createState() => _PlanPaymentPageState();
}

class _PlanPaymentPageState extends State<PlanPaymentPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController buisnesscontroller = TextEditingController();
  TextEditingController address1controller= TextEditingController();
  TextEditingController address2controller= TextEditingController();
  TextEditingController whatsappcontroller= TextEditingController();
  TextEditingController phonecontroller= TextEditingController();
  TextEditingController pincontroller= TextEditingController();

  var planId,planName,planAmount;
  bool loading= true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    planId = Get.arguments[0];
    planName = Get.arguments[1];
    planAmount = Get.arguments[2];
    print("Detail of plan"+planId.toString()+" "+planName.toString()+" "+planAmount.toString());
    getData();
  }
  GetStorage box = GetStorage();
  var token;

  Future getData() async{
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    getProfileData(token);
    getCartProducts(token);
  }

var BusinessName,firAddress,secAddress,pinCode,whatsApp,phoneNumber,numItem;
  List cartList = [];
bool flag = false;
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
      String busName= jsonData['data']['bussness_name'];
      String add01= jsonData['data']['address_1'];
      String add02= jsonData['data']['address_2'];
      String pin= jsonData['data']['pincode'];
      var whats= jsonData['data']['whatsapp'];
      var phnumber= jsonData['data']['mobile'];
      // String add= jsonData['data']['address'];
      // String comId= jsonData['data']['company_id'];

      setState(() {
        BusinessName = busName ;
        firAddress=add01;
        secAddress=add02;
        pinCode=pin;
        whatsApp=whats;
        phoneNumber=phnumber;
        loading = false;
        buisnesscontroller.text= BusinessName;
        address1controller.text = firAddress;
        address2controller.text = secAddress;
        pincontroller.text = pinCode;
        whatsappcontroller.text = whatsApp;
        phonecontroller.text = phoneNumber;

      });

    }else{
      print("No data Found");
    }
  }

  Future<void> purchase_plan(token) async {
    String url = ApiConfig().baseurl + ApiConfig().api_purchase_plan+planId.toString();
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    //
    var headers = {
    'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = {
      'bussiness_name': buisnesscontroller.text,
      'address_1': address1controller.text,
      'address_2': address2controller.text,
      'whatsapp': whatsappcontroller.text,
      'phone_number':phonecontroller.text,
      'pincode': pincontroller.text
    };

    var response =
    await http.put(Uri.parse(requestUrl), body: body,headers: headers);
    print("purchase" + response.body);
    print("purchase url" + url);
    var jsonData = jsonDecode(response.body);
    print("purchase" + response.body);
    print("purchase Header" + headers.toString());

    if (response.statusCode == 200) {
      if(jsonData['success']==false ){

      }
      Fluttertoast.showToast(msg: jsonData['message'],
          timeInSecForIosWeb: 7,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
      print("plan purchased");
      setState((){

      });
      Get.offAll(bottomBar(bottom: 0));

    }
    else {
      print("Failed to login");
      Fluttertoast.showToast(msg: jsonData['messge'].toString(),
          timeInSecForIosWeb: 7,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white
      );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:flag==false?
      AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: const Text("Plan Payment"),
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
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormFieldWidget(hintText: 'Buisness Name',
                    obscureText: false,
                    textInputType: TextInputType.text,
                    controller: buisnesscontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Buisness Name",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Address1',
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: address1controller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Address1",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Address2',
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: address2controller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Address2",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Whatsapp No.',
                    textInputType: TextInputType.phone,
                    obscureText: false,
                    controller: whatsappcontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Whatsapp No.",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Phone No.',
                    textInputType: TextInputType.phone,
                    controller: phonecontroller,
                    obscureText: false,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Phone No.",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Pin Code',
                    textInputType: TextInputType.number,
                    obscureText: false,
                    controller: pincontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Area Pincode",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: (){
                    if(formkey.currentState!.validate()){
                      Fluttertoast.showToast(msg:  double.parse(planAmount.toString()).toString());
                      // purchase_plan(token);
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
                              transactions:  [
                                {
                                  "amount": {
                                    // "total": double.parse(planAmount.toString()).toString(),
                                    "total":"0.01",
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
                                        "name": planName.toString(),
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
                                var response = params;
                                purchase_plan(token);
                                print("objectSuccess" + response["payerID"]);
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


                      return;
                    }else{

                    }

                  },
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1,color: Colors.indigo),
                      borderRadius: BorderRadius.circular(0.5)
                    ),
                      child: Image.asset('assets/images/paypal.png',scale: 2,)
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
