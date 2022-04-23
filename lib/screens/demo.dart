import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart'as http;

import 'login.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  List SellerData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            follow_unfollow();
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
            child: Text("Demo")
          ),
        ),
      ),
    );
  }

  Future<void> getAllSeller() async {

    String url = ApiConfig().baseurl + ApiConfig().api_getAll_seller_page+"1"+"&&limit=3";
    var requestUrl = url;

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGVjaG5vbGl0ZS5pblwvc3RhZ2luZ1wvYXNkYWRtaW5cL2FwaVwvbG9naW4iLCJpYXQiOjE2NDQwNjU4ODEsImV4cCI6MTY0NjY1Nzg4MSwibmJmIjoxNjQ0MDY1ODgxLCJqdGkiOiJLTndVdnpHSUFPUmRIZkJzIiwic3ViIjozLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.Qm1z17mWCOHaSFTKcKzuoHxfrv7zoP4x4VVaS_dW26M'

    };


    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);

    print("allSeller request url" + requestUrl);
    print("allSeller api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("allSellerHeader" + headers.toString());
    print("allSellerresponse" + jsonData['status'].toString());
    if (response.statusCode == 200) {
      if(jsonData['status']=="Token is Expired"){
        //box.remove('is_login');
        Get.offAll(()=>const LoginPage());
      }
      if(jsonData['success']==true)
      {
        print("allSellerSuccess");
        //var sellData= jsonData['data']['data'];

        //print("abc"+sellData.toString());

        setState(() {

          SellerData.addAll(jsonData['data']['data']);
          Fluttertoast.showToast(msg: SellerData.length.toString());

          //SellerId = [];
        });
        // for (int i =0 ; i<SellerData.length;i++){
        //
        //   SellerId.add(SellerData[i]['id']);
        //   //print("sellerIds: "+ SellerId.toString());
        //   // getAllSellerProducts(token,SellerData[i]['id']);
        // }
        //print("sellerIds: "+ SellerId.toString());
        //print('SellerData=>'+SellerData.toString());
      }

    }else{
      print("No data Found");
    }
  }

  Future<void> follow_unfollow() async {

    String url =
        ApiConfig().baseurl + ApiConfig().api_follow_seller + "2";
    var requestUrl = url;
    print("userFollow request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGVjaG5vbGl0ZS5pblwvc3RhZ2luZ1wvYXNkYWRtaW5cL2FwaVwvbG9naW4iLCJpYXQiOjE2NDQwNjU4ODEsImV4cCI6MTY0NjY1Nzg4MSwibmJmIjoxNjQ0MDY1ODgxLCJqdGkiOiJLTndVdnpHSUFPUmRIZkJzIiwic3ViIjozLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.Qm1z17mWCOHaSFTKcKzuoHxfrv7zoP4x4VVaS_dW26M'
    };

    var response = await http.post(Uri.parse(requestUrl), headers: headers);

    print("userFollow request url" + requestUrl);
    print("userFollow api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("userFollow Header" + headers.toString());
    // print("ProductDetailresponse" + jsonData['data'][0].toString());
    if (response.statusCode == 200) {
      if (jsonData['status'] == "Token is Expired") {
        //box.remove('is_login');
        Get.offAll(() => const LoginPage());
      }
      print("userFollow Success");
      SellerData.clear();
      getAllSeller();



      // print('categories' + proDetail.toString());
    } else {
      print("No data Found");
    }
  }
}
