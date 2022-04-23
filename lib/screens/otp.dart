import 'dart:convert';

import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Stack/otpstackwidget.dart';
import 'package:asd/custombutton/button.dart';
import 'package:asd/customtext/text.dart';
import 'package:asd/screens/login.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPscreen extends StatefulWidget {
  const OTPscreen({Key? key}) : super(key: key);

  @override
  _OTPscreenState createState() => _OTPscreenState();
}

class _OTPscreenState extends State<OTPscreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController otpController= TextEditingController();
  String currentText = "";
  CountDownController _controller = CountDownController();
  var otp ,user, pass;
  List Data = [];
  bool timerstatus=false;
  GetStorage box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Data = Get.arguments;
    otp = Data[0];
    otpController.text = otp;
    user = Data[1];
    pass = Data[2];
    // print("argsOtp"+user+pass);

  }

  Future<void> submitOtp() async {


    String url = ApiConfig().baseurl + ApiConfig().api_login;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    //
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var body = {
      'username': user,
      'password': pass,
      'otp':otpController.text
    };


    // print("Body response"+body.toString());
    var response =
    await http.post(Uri.parse(requestUrl), body: body,headers: headers);
    print("fvdshfbhgdf" + response.body);
    var jsonData = jsonDecode(response.body);
    print("fvdshfbhgdf" + response.body);
    print("fvdshfbhgdfHeader" + headers.toString());

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: jsonData['message'],
          timeInSecForIosWeb: 7,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white
      );
      print("login success");
      var otp = jsonData['data']['access_token'];
      print("otp"+ otp.toString());

      setState(() {
        box.write('token',otp);
        box.write("is_login", true);
      });
      Get.offAll(()=>bottomBar(bottom:0));
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                color: Colors.blue,
                width: MediaQuery.of(context).size.width,

                child: Image.asset('assets/images/register.png',width: MediaQuery.of(context).size.width,
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 250.0),
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(left: 10,right: 10),

                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5,color: Colors.grey,),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: Form(
                      key: formkey,
                      child: Column(

                        children: [
                          SizedBox(height: 30,),
                          TextPage(text: "OTP"),
                          SizedBox(height: 30,),

                          Container(
                            margin: EdgeInsets.only(right: 5,left: 5),
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 3) {
                                  return "Please enter correct otp";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  inactiveFillColor: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(1),
                                  fieldHeight: 60,
                                  fieldWidth: 60,
                                  activeFillColor: Colors.pink.shade50,
                                  activeColor: Color(0xffEC1B23),
                                  selectedColor: Colors.black12,
                                  borderWidth: 1,
                                  inactiveColor: Colors.black12),
                              cursorColor: Colors.black12,
                              animationDuration: Duration(milliseconds: 300),
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              onCompleted: (v) {
                                print("Completed");
                              },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                          ),


                          SizedBox(height: 0,
                          ),
                          Container(

                              margin: const EdgeInsets.all(2.0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      timerstatus==false? CircularCountDownTimer(

                                        width: MediaQuery.of(context).size.width / 10,
                                        height: size.height*0.1,

                                        duration:120,

                                        fillColor: Colors.white,
                                        ringColor: Color(0xffEC1B23),
                                        // color: Colors.white30,
                                        controller: _controller,
                                        // backgroundColor: Colors.white54,
                                        // strokeWidth: 10.0,
                                        // strokeCap: StrokeCap.round,
                                        isTimerTextShown: true,
                                        isReverse: true,


                                        onComplete: () async {

                                          setState(() {
                                            timerstatus=true;
                                          });

                                        },
                                        textStyle: TextStyle(fontSize: 14.0,color: Colors.grey),
                                      ):Container(),
                                      InkWell(
                                          onTap: () {},child: timerstatus==false?
                                      Text("Sec",
                                        style: TextStyle(fontSize: 16,color: Colors.grey,),):Container()),
                                    ],
                                  ),


                                  //SizedBox(width: 200,),
                                  InkWell(
                                      onTap: () {
                                        Get.offAll(()=>LoginPage());
                                      },child: timerstatus==true?
                                  Text("Resend",
                                    style: TextStyle(fontSize: 18,color: Colors.grey,
                                        fontWeight: FontWeight.bold),):Container()), ],)
                          ),
                          SizedBox(height: 20,),
                          CustomButton(trailingIcon: Icon(Icons.arrow_forward),
                            inputText: 'Submit',
                            background: Color(0xffEC1B23),
                            onpressed: () {
                              if(formkey.currentState!.validate()){
                              submitOtp();

                              }

                            },


                          ),

                          SizedBox(height: 20,)


                        ],
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
