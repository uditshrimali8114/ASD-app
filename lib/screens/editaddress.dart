
import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/screens/aftercart_address.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/custombutton/Buttonwithouticon.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:asd/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({Key? key}) : super(key: key);

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {

  bool flag= false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController address1controller = TextEditingController();
  TextEditingController address2controller = TextEditingController();
  TextEditingController lendmarkcontroller = TextEditingController();
  TextEditingController pincontroller = TextEditingController();
  var token,cartStatus,name01,address01,address02,pincode,landmark;
  GetStorage box = GetStorage();
  bool loading = true;

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
      var name= jsonData['data']['name'];
      String add1= jsonData['data']['address_1'];
      String add2= jsonData['data']['address_2'];
      String landm= jsonData['data']['landmark'];
      String pinc= jsonData['data']['pincode'];


      setState(() {
        name01 = name;
        address01 = add1;
        address02 = add2;
        landmark = landm;
        pincode = pinc;
        loading = false;
        namecontroller.text = name01;
        address1controller.text = address01;
        address2controller.text = address02;
        lendmarkcontroller.text = landmark;
        pincontroller.text = pincode;
      });

    }else{
      print("No data Found");
    }
  }

  Future<void> UpdateProfileData(token) async{

    String url = ApiConfig().baseurl + ApiConfig().api_update_address;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };

    var request = http.Request('PUT', Uri.parse(requestUrl));
    request.bodyFields = {
      'name': namecontroller.text,
      'address_1': address1controller.text,
      'address_2': address2controller.text,
      'landmark': lendmarkcontroller.text,
      'pincode': pincontroller.text
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);


    if (response.statusCode == 200) {
      if(jsondata['success']==true){
        print("EditAddress"+jsondata.toString());
        Fluttertoast.showToast(msg: jsondata['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        Get.to(()=>AddressPage());
      }
      else
        {
          Fluttertoast.showToast(msg: jsondata['message'],
              timeInSecForIosWeb: 7,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white
          );
          print("EditAddress"+jsondata.toString());
        }
    }
    else {
      print("failed"+response.reasonPhrase.toString());
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
        title: Text("Edit Address"),
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
        child: loading == true
            ? Center(
          child: Container(
              margin: EdgeInsets.only(top: 100),
              child: CircularProgressIndicator()),
        )
            :Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormFieldWidget(hintText: 'Your Name',
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: namecontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Name",
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
                TextFormFieldWidget(hintText: 'Landmark',
                    textInputType: TextInputType.text,
                    controller: lendmarkcontroller,
                    obscureText: false,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Landmark",
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
                Buttonwithouticon(onpressed: () {
                  if(formkey.currentState!.validate()){
                    UpdateProfileData(token);
                  }
                }, inputText: 'Submit',)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
