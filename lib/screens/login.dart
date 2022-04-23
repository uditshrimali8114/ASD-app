
import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/custombutton/button.dart';
import 'package:asd/customtext/linetext.dart';
import 'package:asd/customtext/text.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:asd/screens/forgotpassword.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:asd/screens/registeredaccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'otp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GetStorage box = GetStorage();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Future<void> Login() async {


    String url = ApiConfig().baseurl + ApiConfig().api_otp;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    //
    Map<String, String> headers = {
      // 'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    print("LoginHeader" + headers.toString());
    // var body = jsonEncode();


    // print("Body response"+body.toString());
    var response =
    await http.post(Uri.parse(requestUrl), body: {
      'username': userController.text,
      'password': passwordController.text
    },headers: headers);
    print("Login Response" + response.body);
    var jsonData = jsonDecode(response.body);
    print("decoded" + jsonData.toString());


    if (response.statusCode == 200) {
      if(jsonData['succes']==false){
        Fluttertoast.showToast(msg: jsonData['messge'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white
        );
      }
      if(jsonData['success']==false){
        Fluttertoast.showToast(msg: jsonData['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white
        );
      }
      if(jsonData['success']==true){
        Fluttertoast.showToast(msg: jsonData['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        print("login success");
        var otp = jsonData['data']['otp'];
        print("otp"+ otp.toString());

        setState(() {

        });
        Get.to(()=>OTPscreen(),arguments: [otp,userController.text,passwordController.text]);

      }

    }
    else {
      print("Failed to login");
      Fluttertoast.showToast(msg: jsonData['message'],
          timeInSecForIosWeb: 7,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white
      );

    }
  }


  // Future<void> Login() async {
  //
  //   var headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded'
  //   };
  //   var request = http.Request('POST', Uri.parse('https://technolite.in/staging/asdadmin/api/send_otp'));
  //   request.bodyFields = {
  //     'username': userController.text,
  //     'password': passwordController.text
  //   };
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   var responsed = await http.Response.fromStream(response);
  //   var jsondata = jsonDecode(responsed.body);
  //   // Map<String, dynamic> map = jsonDecode(rawJson);
  //   print('object'+jsondata.toString());
  //   if (response.statusCode == 200) {
  //     print("if"+await response.stream.bytesToString());
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          //height: MediaQuery.of(context).size.height,
          // height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                color: Colors.blue,
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/login.png',),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 250.0),
                child: SingleChildScrollView(
                  child: Container(
                      // height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(left: 10,right: 10),

                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(width: 1.5,color: Colors.grey,),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),topRight: Radius.circular(30))
                      ),
                      child: Form(
                        key: formkey,
                        child: Column(

                          children: [
                            SizedBox(height: 30,),
                            TextPage(text: "Login"),
                            SizedBox(height: 30,),

                            TextFormFieldWidget(hintText: 'Username',
                                textInputType: TextInputType.emailAddress,
                                controller: userController,
                                functionValidate: commonValidation,
                                parametersValidate: "Please Enter Username",
                                onSubmitField: (){},
                                onFieldTap: (){}, obscureText: false,),
                            SizedBox(height: 20,),



                            // TextFormFieldWidget(hintText: 'Password',
                            //     textInputType: TextInputType.visiblePassword,
                            //     controller: passwordController,
                            //     functionValidate: commonValidation,
                            //     obscureText: true,
                            //     parametersValidate: "Please Enter Your Password",
                            //     onSubmitField: (){},
                            //     onFieldTap: (){}),

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
                                hintText: 'Password',
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


                            SizedBox(height: 20,),
                            CustomButton(trailingIcon: Icon(Icons.arrow_forward), inputText: 'Login',
                              background: Color(0xffEC1B23),
                              onpressed: () {
                                if(formkey.currentState!.validate()){
                                  Login();
                                  return;
                                }else{

                                }

                              },


                            ),
                            SizedBox(height: 20,),

                            // ForgetPass
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => ForgotPassword()));
                              },
                              child: Container(
                                  width: size.width*0.95,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1),
                                      border: Border.all(color: Colors.grey,width: 1)

                                  ),
                                  child: const Text('FORGOT PASSWORD',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),)
                              ),
                            ),



                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => RegisteredPage()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Don't have an account?",style: TextStyle(color: Colors.grey),),
                                  Text("Signup",style: TextStyle(color: Color(0xffEC1B23)),),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,)

                          ],
                        ),
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
