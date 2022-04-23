
import 'dart:convert';
import 'dart:io';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/screens/buyerfollower.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/search_page.dart';
import 'package:asd/screens/sellerfollow_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:asd/custombutton/Buttonwithouticon.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditSellerProfilePage extends StatefulWidget {
  const EditSellerProfilePage({Key? key}) : super(key: key);

  @override
  _EditSellerProfilePageState createState() => _EditSellerProfilePageState();
}

class _EditSellerProfilePageState extends State<EditSellerProfilePage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController namecontroller= TextEditingController();
  TextEditingController usernamecontroller= TextEditingController();
  TextEditingController emailcontroller= TextEditingController();
  TextEditingController whatsappcontroller= TextEditingController();
  TextEditingController phonecontroller= TextEditingController();
  GetStorage box = GetStorage();
  var token,name,userName,email,mobileNum,profilePic,whatsapp,userType,numfollowing,numFollowers,numProducts;
  bool loading = true;
  List cartList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }



  Future getData() async{
    var savedValue = box.read('token');
    setState(() {
      token = savedValue;
    });
    getProfileData(token);
    getCartProducts(token);
  }

  File? imageCapture;

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
      if (jsonData['status']=="Token is Invalid") {
        box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("Success");
      var empId= jsonData['data']['id'];
      String firname01= jsonData['data']['name'];
      String username= jsonData['data']['username'];
      String email01= jsonData['data']['email'];
      String mobile= jsonData['data']['mobile'];
      var propic= jsonData['data']['profile_image'];
      var whtsup= jsonData['data']['whatsapp'];
      var user_type= jsonData['data']['user_type'];
      var following= jsonData['data']['followings'];
      var followers= jsonData['data']['followers'];
      var prods= jsonData['data']['product'];

      setState(() {
        name = firname01;
        userName = username;
        email = email01;
        mobileNum = mobile;
        profilePic = propic;
        whatsapp = whtsup;
        loading = false;
        userType=user_type;
        numfollowing = following;
        numFollowers = followers;
        numProducts = prods;
        namecontroller.text = name;
        usernamecontroller.text = userName;
        emailcontroller.text =  email;
        phonecontroller.text = mobileNum;
        if ( whatsapp== null){
        }else{
          whatsappcontroller.text = whatsapp ;
        }

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
      if (jsonData['success'] == false) {
        setState(() {
          // loading = false;
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

  Upload(token) async {
    String url = ApiConfig().baseurl + ApiConfig().api_update;
    var headers = {
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      '_method': 'PUT',
      'name': namecontroller.text,
      'username': usernamecontroller.text,
      'email': emailcontroller.text,
      'mobile': phonecontroller.text,
      'whatsapp': whatsappcontroller.text
    });

    var body = {
      '_method': 'PUT',
      'name': namecontroller.text,
      'username': usernamecontroller.text,
      'email': emailcontroller.text,
      'mobile': phonecontroller.text,
      'whatsapp': whatsappcontroller.text
    };
    print("body"+ body.toString());
    print("headers"+ headers.toString());

    if (imageCapture == null) {
      // request.files.add(await http.MultipartFile.fromPath('profilePhoto', ));
      // request.headers.addAll(headers);
    } else {
      request.files.add(await http.MultipartFile.fromPath(
          'profile', imageCapture!.path));
    }

    // request.files.add(await http.MultipartFile.fromPath('profile', '/C:/Users/INDIA/Downloads/Rectangle 16.png'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);


    print("responseUpdateProfile"+jsondata.toString());
    // var jsondata = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if(jsondata['success']==true){
        print("responseUpdateProfile"+jsondata.toString());
        Fluttertoast.showToast(msg: jsondata['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white
        );
        var Bottom = 0;
        Get.offAll(()=>bottomBar(bottom: Bottom,));
        print("responseUpdateProfile "+await response.stream.bytesToString());
      }

      if(jsondata['succes']==false){
        Fluttertoast.showToast(msg: jsondata['messge'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white
        );
      }

    }
    else {
      print("responseUpdateProfile Faild "+response.reasonPhrase.toString());
    }
  }

  void selectImage() async {
    print("imagepicker ");
    var imagepicker = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      imageCapture = imagepicker as File;
    });
    //print("imagepicker " + imagepicker.path);
  }


bool flag = false;
  var size,height,width,numItem;
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
        title: const Text("Edit Profile"),
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
      body: SingleChildScrollView(
        child: loading==true?Center(
          child: Container(
              margin: EdgeInsets.only(top: 100),
              child: CircularProgressIndicator()),
        ):Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(height: size.height*0.05,),
                Stack(
                  children: [
                    Container(
                      width: size.width*0.3,
                      height: size.height*0.14,

                      child:profilePic==null?
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: imageCapture == null?
                            DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage('assets/images/profileimg.png'),
                            ):
                            DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: FileImage(File(imageCapture!.path)),
                            ),
                            border: Border.all(
                              color:Colors.white,
                              // width: 8,
                            )
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: imageCapture == null?
                            DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(profilePic),
                            ):
                            DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: FileImage(File(imageCapture!.path)),
                            ),
                            border: Border.all(
                              color:Colors.white,
                              // width: 8,
                            )
                        ),
                      )
                      ,
                    ),
                    Positioned(
                      left: size.width*0.18,top: 60,
                      child: GestureDetector(
                        onTap: (){
                          selectImage();
                        },
                        child: Container(
                          height: size.height*0.05,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xfffbd1d3),width: 3.5)
                          ),
                          child: CircleAvatar(
                            backgroundColor: Color(0xffEC1B23),
                            child: Image.asset('assets/images/foundation_photo.png',scale: 1.2,),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.height*0.01,),
                Text("$name",textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22,color: Colors.grey,fontWeight: FontWeight.bold),),
                SizedBox(height: size.height*0.01,),
                userType== 2 ?
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$numProducts Product",style: TextStyle(fontSize: 16,color: Colors.grey),),
                      Text("|",style: TextStyle(fontSize: 16,color: Colors.grey),),
                      GestureDetector(
                          onTap:(){
                            Get.to(()=>sellerfollower());
                          },
                          child: Text("$numFollowers Followers",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                      Text("|",style: TextStyle(fontSize: 16,color: Colors.grey),),
                      GestureDetector(
                          onTap:(){
                            Get.to(()=>sellerfollower());
                          },
                          child: Text("$numfollowing Following",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                    ],
                  ),
                ):
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: GestureDetector(
                      onTap: (){
                        Get.to(()=>buyerfollower());
                      },
                      child: Text("$numfollowing Following",style: TextStyle(fontSize: 16,color: Colors.grey),)),
                ),
                SizedBox(height: size.height*0.03,),
                TextFormFieldWidget(hintText: 'Name',
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: namecontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Name",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'User name',
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: usernamecontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Username",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Email Address',
                    textInputType: TextInputType.emailAddress,
                    obscureText: false,
                    controller: emailcontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Email",
                    onSubmitField: (){}, onFieldTap: (){}),
                SizedBox(
                  height: 20,
                ),
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
                    hintText: 'Phone Number',
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
                  controller: phonecontroller,
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
                    hintText: 'Whats\'sapp Number',
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
                  controller: whatsappcontroller,
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
                  height: 30,
                ),
                Buttonwithouticon(onpressed: () {
                  if(formkey.currentState!.validate()){

                  }
                  Upload(token);
                }, inputText: 'Save',)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
