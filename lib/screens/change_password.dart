import 'dart:convert';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool flag = false;
  bool loading = true;
  List cartList = [];
  var numItem, size, height, width, token;
  GetStorage box = GetStorage();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController NewPassController = TextEditingController();
  TextEditingController OldPassController = TextEditingController();
  TextEditingController ConfPassController = TextEditingController();

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

  Future<void> ChangePass(token) async {
    String url = ApiConfig().baseurl + ApiConfig().api_change_password;
    var requestUrl = url;
    print("changePass request url-->" + url.toString());

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('PUT', Uri.parse(requestUrl));
    request.bodyFields = {
      'current_password': OldPassController.text,
      'new_password': NewPassController.text,
      'confirm_password': ConfPassController.text
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);
    print("changePass"+jsondata.toString());
    if (response.statusCode == 200) {
      if (jsondata['success']==false){
        Fluttertoast.showToast(
            msg: jsondata['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (jsondata['succes']==false){
        Fluttertoast.showToast(
            msg: jsondata['messge'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // if(jsondata['message']== "Bad request"){
        //   if(jsondata['data']['new_password']!=null){
        //     Fluttertoast.showToast(
        //         msg: jsondata['data']['new_password'],
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.SNACKBAR,
        //         timeInSecForIosWeb: 1,
        //         backgroundColor: Colors.red,
        //         textColor: Colors.white,
        //         fontSize: 16.0);
        //   }
        //   else if(jsondata['data']['current_password']!=null){
        //     Fluttertoast.showToast(
        //         msg: jsondata['data']['current_password'],
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.SNACKBAR,
        //         timeInSecForIosWeb: 1,
        //         backgroundColor: Colors.red,
        //         textColor: Colors.white,
        //         fontSize: 16.0);
        //   }
        //   else{
        //     Fluttertoast.showToast(
        //         msg: jsondata['data']['confirm_password'],
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.SNACKBAR,
        //         timeInSecForIosWeb: 1,
        //         backgroundColor: Colors.red,
        //         textColor: Colors.white,
        //         fontSize: 16.0);
        //   }
        //
        // }

      //   else{
      //     Fluttertoast.showToast(
      //         msg: jsondata['message'],
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.SNACKBAR,
      //         timeInSecForIosWeb: 1,
      //         backgroundColor: Colors.red,
      //         textColor: Colors.white,
      //         fontSize: 16.0);
      //
      // }

      }
      if (jsondata['success']==true){
        print("changePass"+jsondata.toString());
        Get.offAll(()=>bottomBar(bottom: 0));
        Fluttertoast.showToast(
            msg: jsondata['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      print("changePass"+jsondata.toString());
      print("Changed" + await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: const Text("Change Password"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: const Color(0xffEC1B23),
              borderRadius: const BorderRadius.only(
                  bottomLeft: const Radius.circular(25))),
        ),
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: GestureDetector(
            onTap: () {
              Get.offAll(() => bottomBar(bottom: 0));
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
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const Cart()));
                  },
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/cart.png',
                        scale: 3,
                      ),
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
                                  color: const Color(0xffFFC960)),
                              child: Text(
                                numItem == null ? "0" : numItem.toString(),
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
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextFormFieldWidget(
                      hintText: 'Current Password',
                      textInputType: TextInputType.text,
                      obscureText: false,
                      controller: OldPassController,
                      functionValidate: commonValidation,
                      parametersValidate: "Enter Your Current Password",
                      onSubmitField: () {},
                      onFieldTap: () {}),
                  const SizedBox(
                    height: 35,
                  ),
                  TextFormFieldWidget(
                      hintText: 'New Password',
                      textInputType: TextInputType.text,
                      obscureText: false,
                      controller: NewPassController,
                      functionValidate: commonValidation,
                      parametersValidate: "Enter Your New Password",
                      onSubmitField: () {},
                      onFieldTap: () {}),
                  const SizedBox(
                    height: 35,
                  ),
                  TextFormFieldWidget(
                      hintText: 'Confirm Password',
                      textInputType: TextInputType.text,
                      obscureText: false,
                      controller: ConfPassController,
                      functionValidate: commonValidation,
                      parametersValidate: "Enter Your Confirm Password",
                      onSubmitField: () {},
                      onFieldTap: () {}),
                  const SizedBox(
                    height: 65,
                  ),
                  Container(
                    height: 45,
                    width: width * .8,
                    color: Color(0xffEC1B23),
                    child: FlatButton(
                      onPressed: () {
                        if(formkey.currentState!.validate()){
                          ChangePass(token);
                          return;
                        }else{

                        }
                      },
                      child: Text(
                        "Change Password",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
