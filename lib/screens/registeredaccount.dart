// import 'package:asd/Stack/loginstackwidgets.dart';
// import 'package:asd/Stack/registeredstackwidgets.dart';
import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/custombutton/button.dart';
import 'package:asd/customtext/text.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart'as http;

class RegisteredPage extends StatefulWidget {
  const RegisteredPage({Key? key}) : super(key: key);

  @override
  _RegisteredPageState createState() => _RegisteredPageState();
}

class _RegisteredPageState extends State<RegisteredPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController yournameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnfpasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> Register() async {


    String url = ApiConfig().baseurl + ApiConfig().api_register;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    //
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'

    };

    var body = {
      'name': yournameController.text,
      'username': usernameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'password': passwordController.text,
      'confirm_password': cnfpasswordController.text
    };


    // print("Body response"+body.toString());
    var response =
    await http.post(Uri.parse(requestUrl), body: body,headers: headers);
    print("fvdshfbhgdf" + response.body);
    var jsonData = jsonDecode(response.body);

    print("fvdshfbhgdf" + jsonData.toString());
    print("fvdshfbhgdfHeader" + headers.toString());

    if (response.statusCode == 200) {
      if (jsonData["success"]==true ){
        Get.offAll(LoginPage());
        Fluttertoast.showToast(msg: jsonData['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white
        );
        print("login success");
        var otp = jsonData['data']['otp'];
        print("otp"+ otp.toString());

        setState(() {

        });
      }
      if(jsonData["succes"]==false ){
        Fluttertoast.showToast(msg: jsonData['messge'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white
        );
      }


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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                color: Colors.blue,
                padding: EdgeInsets.only(bottom: 100),
                child: Image.asset(
                  'assets/images/login.png',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 230.0),
              child: Container(

                  height: MediaQuery.of(context).size.height*0.97,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1.5,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        TextPage(text: "Register Account"),
                        SizedBox(
                          height: 30,
                        ),
                        // Name TFF yournameController

                        TextFormField(
                          cursorColor: Colors.grey,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          // textInputAction: widget.actionKeyboard,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter name',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.2,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 8.0, right: 8.0),
                            isDense: true,
                            errorStyle: TextStyle(
                              color: Color(0xffEC1B23),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.2,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                          ),
                          controller: yournameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your Name!';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // if (widget.onSubmitField != null) widget.onSubmitField();
                          },
                          onTap: () {
                            // if (widget.onFieldTap != null) widget.onFieldTap();
                          },
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        //User Name usernameController Please Enter Your Username
                        TextFormField(
                          cursorColor: Colors.grey,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          // textInputAction: widget.actionKeyboard,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter User Name',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.2,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 8.0, right: 8.0),
                            isDense: true,
                            errorStyle: TextStyle(
                              color: Color(0xffEC1B23),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.2,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                          ),
                          controller: usernameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter User Name!';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // if (widget.onSubmitField != null) widget.onSubmitField();
                          },
                          onTap: () {
                            // if (widget.onFieldTap != null) widget.onFieldTap();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Email emailController Please Enter Email
                        TextFormField(
                          cursorColor: Colors.grey,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          // textInputAction: widget.actionKeyboard,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.2,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 8.0, right: 8.0),
                            isDense: true,
                            errorStyle: TextStyle(
                              color: Color(0xffEC1B23),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.2,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Please Enter Valid Email';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // if (widget.onSubmitField != null) widget.onSubmitField();
                          },
                          onTap: () {
                            // if (widget.onFieldTap != null) widget.onFieldTap();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Mobile Number mobileController Please Enter Your Mobile Number
                        TextFormField(
                          cursorColor: Colors.grey,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          // textInputAction: widget.actionKeyboard,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Mobile Number',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.2,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 8.0, right: 8.0),
                            isDense: true,
                            errorStyle: TextStyle(
                              color: Color(0xffEC1B23),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.2,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                          ),
                          controller: mobileController,
                          validator: (value) {
                            if (value!.isEmpty ||value.length!=10) {
                              return 'Please Enter Valid Mobile Number';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // if (widget.onSubmitField != null) widget.onSubmitField();
                          },
                          onTap: () {
                            // if (widget.onFieldTap != null) widget.onFieldTap();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Password passwordController Please Enter Password
                        TextFormField(
                          cursorColor: Colors.grey,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          // textInputAction: widget.actionKeyboard,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.2,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 8.0, right: 8.0),
                            isDense: true,
                            errorStyle: TextStyle(
                              color: Color(0xffEC1B23),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.2,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                          ),
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty ||value.length < 6) {
                              return 'Password must be grater then 6 character';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // if (widget.onSubmitField != null) widget.onSubmitField();
                          },
                          onTap: () {
                            // if (widget.onFieldTap != null) widget.onFieldTap();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Confirm Password cnfpasswordController Please Enter Your Confirm Password
                        TextFormField(
                          cursorColor: Colors.grey,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          // textInputAction: widget.actionKeyboard,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.2,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 8.0, right: 8.0),
                            isDense: true,
                            errorStyle: TextStyle(
                              color: Color(0xffEC1B23),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.2,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffEC1B23)),
                            ),
                          ),
                          controller: cnfpasswordController,
                          validator: (value) {
                            if (value!.isEmpty ||value.length < 6) {
                              return 'Password and Confirm Password must be same ';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            // if (widget.onSubmitField != null) widget.onSubmitField();
                          },
                          onTap: () {
                            // if (widget.onFieldTap != null) widget.onFieldTap();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          trailingIcon: Icon(Icons.arrow_forward),
                          inputText: 'Register',
                          background: Color(0xffEC1B23),
                          onpressed: () {
                            if(formkey.currentState!.validate()){
                              Register();
                              return;
                            }else{

                            }

                          },
                          // {
                          //   Register();
                          // },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Text(
                                  "Login",
                                  style:
                                      TextStyle(color: Color(0xffEC1B23)),
                                )),
                          ],
                        ),
                        // SizedBox(
                        //   height: 50,
                        // ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
