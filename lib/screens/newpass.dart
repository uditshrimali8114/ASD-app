
import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/custombutton/button.dart';
import 'package:asd/customtext/text.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:asd/screens/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPassword> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GetStorage box = GetStorage();
  var getArgs,otp,userId;
  TextEditingController newPassController = TextEditingController();
  TextEditingController confPassController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArgs = Get.arguments;
    setState(() {
      otp = getArgs[0];
      userId = getArgs[1];
    });
  }

  Future<void> ChangePass() async {


    String url = ApiConfig().baseurl + ApiConfig().api_SubmitNewPass+userId.toString();
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    //
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var body = {
      'otp': otp.toString(),
      'new_password': newPassController.text,
      'confirm_password': confPassController.text
    };


    print("Body response"+body.toString());
    var response =
    await http.post(Uri.parse(requestUrl), body: body,headers: headers);
    print("fvdshfbhgdf" + response.body);
    var jsonData = jsonDecode(response.body);
    print("fvdshfbhgdf" + response.body);
    print("fvdshfbhgdfHeader" + headers.toString());

    if (response.statusCode == 200) {
      if(jsonData['success']==true){
        Get.offAll(()=>LoginPage());
        Fluttertoast.showToast(msg: jsonData['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
      }

      setState(() {

      });

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
  //
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
                          TextPage(text: "New Password"),
                          SizedBox(height: 30,),

                          TextFormFieldWidget(hintText: 'Enter New Password',
                            textInputType: TextInputType.emailAddress,
                            controller: newPassController,
                            functionValidate: commonValidation,
                            parametersValidate: "Please Enter New Password",
                            onSubmitField: (){},
                            onFieldTap: (){}, obscureText: false,),
                          SizedBox(height: 20,),
                          TextFormFieldWidget(hintText: 'Confirm Password',
                              textInputType: TextInputType.visiblePassword,
                              controller: confPassController,
                              functionValidate: commonValidation,
                              obscureText: false,
                              parametersValidate: "Please Enter Confirm Password",
                              onSubmitField: (){},
                              onFieldTap: (){}),
                          SizedBox(height: 20,),
                          CustomButton(trailingIcon: Icon(Icons.arrow_forward), inputText: 'Submit',
                            background: Color(0xffEC1B23),
                            onpressed: () {
                              if(formkey.currentState!.validate()){
                                ChangePass();
                                return;
                              }else{

                              }

                            },


                          ),
                          SizedBox(height: 20,),

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
                                    Get.offAll(()=>LoginPage());
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
