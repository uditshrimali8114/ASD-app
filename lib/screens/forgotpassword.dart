

import 'dart:convert';
import 'package:asd/screens/otp_forget_pass.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart'as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/custombutton/button.dart';
import 'package:asd/customtext/text.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController mobileController= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  Future<void> forgetPassOtp() async {

    String url = ApiConfig().baseurl + ApiConfig().api_forget_otp;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var body = {
      'email':mobileController.text
    };

    var response =
    await http.post(Uri.parse(requestUrl), body: body,headers: headers);
    print("fvdshfbhgdf" + response.body);
    var jsonData = jsonDecode(response.body);
    print("fvdshfbhgdf" + response.body);
    print("fvdshfbhgdfHeader" + headers.toString());

    if (response.statusCode == 200) {
      if(jsonData['success']==false){
        Fluttertoast.showToast(msg:  jsonData['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white
        );
        print("wrong"+ jsonData['message']);
      }
      print("login success");
      var otp = jsonData['data']['otp'];
      var uId = jsonData['data']['user_id'];
      print("otp"+ otp.toString());

      setState(() {

      });
      Get.to(() =>OTPForgetscreen(),arguments: [otp,uId]);
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                child: Image.asset('assets/images/fp.png',width: MediaQuery.of(context).size.width,
                  ),
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
                              topLeft: Radius.circular(20),topRight: Radius.circular(20))
                      ),
                      child: Form(
                        key: formkey,
                        child: Column(

                          children: [
                            SizedBox(height: 30,),
                            TextPage(text: "Forgot Password"),
                            SizedBox(height: 30,),
                            TextFormFieldWidget(hintText: 'Enter Email Address',
                                textInputType: TextInputType.emailAddress,
                                controller: mobileController,
                                obscureText: false,
                                functionValidate: commonValidation,
                                parametersValidate: "Please Enter Your Email Address",
                                onSubmitField: (){},
                                onFieldTap: (){}),
                            SizedBox(height: 20,),

                            CustomButton(trailingIcon: Icon(Icons.arrow_forward), inputText: 'Send OTP',
                              background: Color(0xffEC1B23), onpressed: () {
                                if(formkey.currentState!.validate()){
                                  forgetPassOtp();
                                  return;
                                }else{

                                }
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) => OTPscreen()));

                              },


                            ),
                            // SizedBox(height: 20,)

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
                            SizedBox(
                              height: 20,
                            ),

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
