
import 'package:asd/custombutton/button.dart';
import 'package:asd/customtext/text.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/otp.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPStackWidgets extends StatefulWidget {
  const OTPStackWidgets({Key? key}) : super(key: key);

  @override
  _OTPStackWidgetsState createState() => _OTPStackWidgetsState();
}

class _OTPStackWidgetsState extends State<OTPStackWidgets> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late TextEditingController otpController;
  String currentText = "";
  CountDownController _controller = CountDownController();

  bool timerstatus=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otpController = TextEditingController();

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: MediaQuery.of(context).size.height,
      // height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,

            child: Image.asset('assets/images/register.png',width: MediaQuery.of(context).size.width,
              height: 280,),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: SingleChildScrollView(
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
                                      height: size.height*0.05,

                                      duration:120,

                                      fillColor: Colors.white,
                                      // fillColor: Colors.white30,
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
                                      textStyle: TextStyle(fontSize: 14.0,color: Colors.grey), ringColor: Color(0xffEC1B23),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          OTPscreen()));
                                    },child: timerstatus==true?
                                Text("Resend",
                                  style: TextStyle(fontSize: 18,color: Colors.grey,
                                      fontWeight: FontWeight.bold),):Container()), ],)
                        ),





                        SizedBox(height: 20,),
                        CustomButton(trailingIcon: Icon(Icons.arrow_forward),
                          inputText: 'Submit',
                          background: Color(0xffEC1B23), onpressed: () {
                            if(formkey.currentState!.validate()){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => LoginPage()));


                          }

                          },


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
    );
  }

}

