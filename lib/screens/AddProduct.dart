
import 'dart:convert';
import 'dart:io';

import 'package:asd/Api/api_config.dart';
import 'package:asd/Appbar/Customappbar.dart';
import 'package:asd/Bottombar/bottombar.dart';
import 'package:asd/custombutton/Buttonwithouticon.dart';
import 'package:asd/customtextfield/customtextfield.dart';
import 'package:asd/screens/cart.dart';
import 'package:asd/screens/home.dart';
import 'package:asd/screens/login.dart';
import 'package:asd/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http ;
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController productnamecontroller= TextEditingController();
  TextEditingController productcodecontroller= TextEditingController();
  TextEditingController categorycontroller= TextEditingController();
  TextEditingController subcategorycontroller= TextEditingController();
  TextEditingController actualpricecontroller= TextEditingController();
  TextEditingController sellingpricecontroller= TextEditingController();
  TextEditingController deliveryChargcecontroller= TextEditingController();
  TextEditingController descriptioncontroller= TextEditingController();
  GetStorage box = GetStorage();
  var token,SellerData,catValue,selectedCatId,selectedSubCatId,subValue,numItem,newProdId;
  List catName=[];
  List catid=[];
  List cartList=[];
  List category=[];
  bool loading = true;
  List sub_category=[];
  File? imageCapture;
  bool flag  = false;
  bool popup  = false;
  bool skip  = true;
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
    getcategories(token);
    getCartProducts(token);
  }

  Future<void> getcategories(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_categories;
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
    print("response" + jsonData['status'].toString());
    if (response.statusCode == 200) {
      if(jsonData['status']=="Token is Expired"){
        box.remove('is_login');
        Get.offAll(()=>LoginPage());
      }
      print("Success");
      var empId= jsonData['data']['data'];

      print("abc"+empId.toString());
      setState(() {
        category = empId;
      });
      for (int i=0; i<category.length;i++){
        catName.add(jsonData['data']['data'][i]['name']);
      }
      print('categories'+catName.toString());

    }else{
      print("No data Found");
    }
  }

  Future<void> fetchSubCategory(token,selectedCatId) async {

    String url = ApiConfig().baseurl + ApiConfig().api_sub_categories+selectedCatId.toString() ;
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("Subcat request url" + requestUrl);
    print("Subcat api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());
    print("Subcat response" + jsonData['data']['data'].toString());
    if (response.statusCode == 200) {
      if(jsonData['status']=="Token is Expired"){
        box.remove('is_login');
        Get.offAll(()=>LoginPage());
      }
      print("Success Subcat");
      var empId= jsonData['data']['data'];

      // print("abc"+empId.toString());
      setState(() {
        sub_category = empId;
      });
      // for (int i=0; i<category.length;i++){
      //   catName.add(jsonData['data']['data'][i]['name']);
      // }
      // print('categories'+catName.toString());

    }else{
      print("No data Found");
    }
  }

  Future<void> AddProducts(token) async {

    // setState(() {
    //   loading = true;
    // });
    String url = ApiConfig().baseurl + ApiConfig().api_add_product;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    //
    var headers = {
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST', Uri.parse(requestUrl));
    request.fields.addAll({
      'product_name': productnamecontroller.text,
      'product_code': productcodecontroller.text,
      'category_id': selectedCatId.toString(),
      'sub_category_id':selectedSubCatId.toString(),
      'actual_price': actualpricecontroller.text,
      'sell_price': sellingpricecontroller.text,
      'delivery_charge': deliveryChargcecontroller.text,
      'description': descriptioncontroller.text
    });
    if (imageCapture == null) {
      // Fluttertoast.showToast(msg: "Please Upload Image Of product".toString(),
      //     timeInSecForIosWeb: 7,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.redAccent,
      //     textColor: Colors.white
      // );
    } else {
      request.files.add(await http.MultipartFile.fromPath(
          'product_image', imageCapture!.path));
    }
    // request.files.add(await http.MultipartFile.fromPath('product_image', '/C:/Users/INDIA/Downloads/1DDFE633-2B85-468D-B28D05ADAE7D1AD8_source.jpg'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);
    print("AddProducts: "+ jsondata.toString());
    if (response.statusCode == 200) {
      print("AddProducts: "+ jsondata.toString());
      if(jsondata['success']==true){
        print("AddProducts: "+ jsondata.toString());
        Fluttertoast.showToast(msg: "Product Added".toString(),
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        setState(() {
          loading = false;
          imageCapture = null;
          newProdId = jsondata['data']['id'];
          popup = true;
          skip = true;
        });
      }if(jsondata['succes']==false){
        Fluttertoast.showToast(msg:jsondata['messge'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
      }
      // print("AddProducts: "+await response.stream.bytesToString());

      // Get.offAll(()=>bottomBar(bottom: 0));
    }
    else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(msg: "Failed to Add new Product".toString(),
          timeInSecForIosWeb: 7,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white
      );
      print("AddProducts: "+ jsondata.toString());
    }

  }

  Future<void> addImage(token) async {

    setState(() {
      loading= true;
    });

    String url = ApiConfig().baseurl + ApiConfig().api_add_product_Images+newProdId.toString();
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    //
    var headers = {
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST', Uri.parse(requestUrl));
    // request.fields.addAll({
    //   'product_name': productnamecontroller.text,
    //   'product_code': productcodecontroller.text,
    //   'category_id': selectedCatId.toString(),
    //   'sub_category_id':selectedSubCatId.toString(),
    //   'actual_price': actualpricecontroller.text,
    //   'sell_price': sellingpricecontroller.text,
    //   'delivery_charge': deliveryChargcecontroller.text,
    //   'description': descriptioncontroller.text
    // });
    if (imageCapture == null) {
      // Fluttertoast.showToast(msg: "Please Upload Image Of product".toString(),
      //     timeInSecForIosWeb: 7,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.redAccent,
      //     textColor: Colors.white
      // );
    } else {
      request.files.add(await http.MultipartFile.fromPath(
          'product_image', imageCapture!.path));
    }
    // request.files.add(await http.MultipartFile.fromPath('product_image', '/C:/Users/INDIA/Downloads/1DDFE633-2B85-468D-B28D05ADAE7D1AD8_source.jpg'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    var jsondata = jsonDecode(responsed.body);
    if (response.statusCode == 200) {
      // success: false
      if(jsondata['success']==true){
        print("AddProducts: "+ jsondata.toString());
        Fluttertoast.showToast(msg: "Product Added".toString(),
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        setState(() {
          loading = false;
          imageCapture = null;
          // popup = true;
          skip = true;
        });
      } if(jsondata['success']==false){
        Fluttertoast.showToast(msg:jsondata['message'],
            timeInSecForIosWeb: 7,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
      }
      // print("AddProducts: "+await response.stream.bytesToString());

      // Get.offAll(()=>bottomBar(bottom: 0));
    }
    else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(msg: "Failed to Add new Product".toString(),
          timeInSecForIosWeb: 7,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white
      );
      print("AddProducts: "+ jsondata.toString());
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
        loading = false;
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

  void selectImage() async {
    print("imagepicker ");
    var imagepicker = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      imageCapture = imagepicker as File;
      skip = false;
    });
    //print("imagepicker " + imagepicker.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:flag==false?
      AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: const Text("Add Product"),
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
      body: loading== true?Center(
        child: CircularProgressIndicator(),
      ):SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
          child: Form(
            key: formkey,
            child:popup==false?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormFieldWidget(hintText: 'Product Name',
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: productnamecontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Product Name",
                    onSubmitField: (){}, onFieldTap: (){}),
                const SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Product Code',
                    obscureText: false,
                    textInputType: TextInputType.visiblePassword,
                    controller: productcodecontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Your Product Code",
                    onSubmitField: (){}, onFieldTap: (){}),
                const SizedBox(
                  height: 20,
                ),

                Container(
                  // margin: EdgeInsets.only(left: 5,right: 5),
                  padding: EdgeInsets.only(left: 5,right: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("Select Category",
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade400)),
                    value: catValue,
                    items: category.map((explist) {
                      print("array " + explist.toString());
                      return DropdownMenuItem(
                        value: explist['name'],
                        child: Text(explist['name'].toString()),
                        onTap: () {
                          selectedCatId = explist['id'];
                          print("City Id "+selectedCatId.toString());
                        },
                      );
                    }).toList(),
                    onChanged: (value) {
                      subValue = null;
                      fetchSubCategory(token,selectedCatId);
                      setState(() {
                        catValue = value.toString();
                        // box.write("city", cityValue);
                        if (selectedCatId == 0) {
                          selectedCatId = null;
                        }
                      });
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5,right: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4)
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("Select Sub category",
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade400)),
                    value: subValue,
                    items: sub_category.map((explist) {
                      print("array " + explist.toString());
                      return DropdownMenuItem(
                        value: explist['name'],
                        child: Text(explist['name']),
                        onTap: () {
                          selectedSubCatId = explist['id'];
                          // print("job Id "+selectedjobId);
                        },
                      );
                    }).toList(),
                    onChanged: (value) {

                      setState(() {
                        subValue = value.toString();
                        // box.write("jobCode", jobValue);
                        // if (selectedjobId == 0) {
                        //   selectedjobId = null;
                        // }
                      });
                    },
                  ),
                ),



                const SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Actual Price',
                    textInputType: TextInputType.number,
                    obscureText: false,
                    controller: actualpricecontroller,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter actual price of product",
                    onSubmitField: (){}, onFieldTap: (){}),
                const SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Selling Price',
                    textInputType: TextInputType.number,
                    controller: sellingpricecontroller,
                    obscureText: false,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter selling price of product",
                    onSubmitField: (){}, onFieldTap: (){}),
                const SizedBox(
                  height: 20,
                ),
                TextFormFieldWidget(hintText: 'Delivery Charge',
                    textInputType: TextInputType.number,
                    controller: deliveryChargcecontroller,
                    obscureText: false,
                    functionValidate: commonValidation,
                    parametersValidate: "Enter Delivey Charges",
                    onSubmitField: (){}, onFieldTap: (){}),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  cursorColor: Colors.grey,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  //textInputAction:,
                  maxLines: 5,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.2,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xffEC1B23)),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.2,
                    ),
                    contentPadding: EdgeInsets.only(
                        top: 12, bottom:12, left: 8.0, right: 8.0),
                    isDense: true,
                    errorStyle: TextStyle(
                      color: Color(0xffEC1B23),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.2,
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffEC1B23)),
                    ),
                  ),
                  controller: descriptioncontroller,
                  validator: (value) {
                    if (descriptioncontroller.text == null) {
                      String resultValidate = "Please give description about product";
                      if (resultValidate != null) {
                        return resultValidate;
                      }
                    }
                    return null;
                  },
                  // onFieldSubmitted: (value) {
                  //   if (widget.onSubmitField != null) widget.onSubmitField();
                  // },
                  // onTap: () {
                  //   if (widget.onFieldTap != null) widget.onFieldTap();
                  // },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Upload Images',textAlign: TextAlign.left,style: TextStyle(
                  fontSize: 16,color: Colors.grey,fontWeight: FontWeight.w400
                ),),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: (){
                    selectImage();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color(0xfffad0d2),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color:Color(0xffEC1B23),width: 1 ),
                      image:imageCapture == null?
                     null:
                      DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: FileImage(File(imageCapture!.path)),
                      ),
                    ),

                    child:imageCapture == null?
                    Text("+", style: TextStyle(fontSize: 35,color: Color(0xffEC1B23),),
                    ):Text(''),
                  ),
                ),

                SizedBox(height: 15,),
                Buttonwithouticon(onpressed: () {
                  if(formkey.currentState!.validate()){
                    AddProducts(token);
                  }

                }, inputText: 'Add Product',),

              ],
            ):
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  alignment: Alignment.center,
                  child:Text("Product Added Successfully",style: TextStyle(
                    fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                  alignment: Alignment.center,
                  child:Text("Do You Want to add more Images ?",style: TextStyle(
                      fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: (){
                    selectImage();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color(0xfffad0d2),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color:Color(0xffEC1B23),width: 1 ),
                      image:imageCapture == null?
                      null:
                      DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: FileImage(File(imageCapture!.path)),
                      ),
                    ),

                    child:imageCapture == null?
                    Text("+", style: TextStyle(fontSize: 35,color: Color(0xffEC1B23),),
                    ):Text(''),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                skip== true?
                Buttonwithouticon(onpressed: () {
                  Get.offAll(()=>bottomBar(bottom: 0));
                }, inputText: 'Skip',):
                Buttonwithouticon(onpressed: () {
                  if (catValue == null){
                    Fluttertoast.showToast(msg: "Please select category".toString(),
                        timeInSecForIosWeb: 7,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white
                    );
                  } if (subValue == null){
                    Fluttertoast.showToast(msg: "Please select sub-category".toString(),
                        timeInSecForIosWeb: 7,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white
                    );
                  }else
                    {
                      addImage(token);
                    }

                }, inputText: 'Add Images',),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
