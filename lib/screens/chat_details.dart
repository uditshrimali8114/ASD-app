import 'dart:async';
import 'dart:convert';

import 'package:asd/Api/api_config.dart';
import 'package:asd/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
class ChatDetails extends StatefulWidget {
  const ChatDetails({Key? key}) : super(key: key);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  var token;
  bool check=false;
  List args = [];
  List chatlist = [];
  bool loading = true;
  int num =1;
  TextEditingController sendtextEditingController = TextEditingController();
  ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  GetStorage box = GetStorage();
  Future getData() async{
    var savedValue = box.read('token');
    // var ab = prevPage[5].toString();
    setState(() {
      // _pageSize = 1;
      args = Get.arguments;
      token = savedValue;
      // isFollowed = ab;
    });
    getMessageWithUser(token);
    // getAllSellerProducts(token);
    // getCartProducts(token);
    // getMessageWithUser(token);
  }
  //id, dp ,name
  Future<void> getMessageWithUser(token) async {
    String url =
        ApiConfig().baseurl + ApiConfig().api_getMessage+args[0].toString();
    var requestUrl = url;
    print("ChatDetails request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(Uri.parse(requestUrl), headers: headers);

    print("ChatDetails request url" + requestUrl);
    print("ChatDetails Details api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("ChatDetails DetailsHeader" + headers.toString());
    // print("ChatDetails message" + jsonData['data'][0]['message'].toString());
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
      print("ChatDetails Success");
      setState(() {

        chatlist = jsonData['data'];
        loading = false;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
      });
      // print("ChatList: "+ChatList.toString());
    }
    else {
      print("No data Found");
    }
  }

  Future<void> sendMessage(token,id,Sendmsg) async {
    sendtextEditingController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    String url =
        ApiConfig().baseurl + ApiConfig().api_sendMessage+id.toString();
    var requestUrl = url;
    print("sendMessage request url-->" + url.toString());
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };
    var body = {
    'message':Sendmsg
    };

    var response = await http.post(Uri.parse(requestUrl), headers: headers,body: body);

    print("sendMessage request url" + requestUrl);
    print("sendMessage Details api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("sendMessage DetailsHeader" + headers.toString());
    // print("sendMessage message" + jsonData['data'][0]['message'].toString());
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
      print("sendMessage Success");
      getMessageWithUser(token);
      setState(() {

        // chatlist = jsonData['data'];
        // loading = false;
        // isLiked = jsonData['data']['data'][0]['user_like'];
        // cartStatus = jsonData['success'];
      });
      // print("ChatList: "+ChatList.toString());
    }
    else {
      print("No data Found");
    }
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Timer(Duration(seconds: 4), () {

      getMessageWithUser(token);
      if(num==1){
        setState(() {
          // scrollController.animateTo(scrollController.position.maxScrollExtent + 100, curve: Curves.easeOut);
          scrollController.jumpTo(scrollController.position.maxScrollExtent+100);
        });

      }
      num = 2;


    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xffEC1B23),
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: SafeArea(
          child:Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.white,),
                ),
                SizedBox(width: 2,),
                args[1]==null?
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage:AssetImage('assets/images/profileimg.png'),
                  maxRadius: 20,
                ):
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage:NetworkImage(args[1]),
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: args[2],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 6,),
                      //Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ) ,
        ),

      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              reverse: false,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12.0);
              },
              controller: scrollController,
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: chatlist.length,
              itemBuilder: (BuildContext context, int index) {
                // final Message message = messages[index];
                var message = chatlist[index];
                final bool isMe =message['flag'] == true;
                final bool isSameUser = message['sender_id'] == '1';

                var datetime = message['created_at'].split("T");
                var dateNew = datetime[0];
                var timeNew = datetime[1].split(".")[0];
                // var path =chatlist[index]['attachment'];

                // var ext =path.split(".").last;
                // if(ext!=''){
                //   print("if ext : "+path.split(".").last);
                //   if(ext=='jpg'){
                //     check =false;
                //   }
                //   else if(ext =='png'){
                //     check =false;
                //
                //   }else{
                //     check =true;
                //   }
                // }else{
                //   print("else ext : "+path.split(".").last);
                // }

                // print("timeedit1 " + datetime.toString());
                // String timeStamp24HR = datetime;
                // var datess = datetime.split(" ");
                // var reciver_date = datess[0];
                // var reciver_time = datess[1];
                // print("timeedit2 "+reciver_time.toString());

                // var timeedit =
                // DateFormat.jm().format(DateTime.parse(timeStamp24HR));

                // print("timeedit"+DateTime.tryParse(document[]).toString());

                // print("date_ Time-->"+reciver_date.toString()+" "+timeedit);
                // prevUserId = message.sender.id;
                return _chatBubble(chatlist[index]['message'], chatlist[index]['attachment'],check,dateNew,
                    timeNew, isMe, isSameUser);
              },
            ),
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: _sendMessageArea(),
          ),
        ],
      ),


    );
  }

  _chatBubble(fetchlist, String image,bool check,String date, String time, bool isMe, bool isSameUser) {
    // print("baseurl_img : "+ApiConfig().baseurl_img+image);
    return Wrap(
      alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
      children: <Widget>[
        Column(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
                color: isMe ? Color(0xffEC1B23) : Colors.white,
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(minWidth: 150),
                        child: Text(fetchlist,
                            style: TextStyle(
                                color: isMe ? Colors.white : Colors.black54)),
                      ),

                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(date,
                    style:
                    TextStyle(fontSize: 10, color: isMe ? Color(0xffEC1B23):Colors.black54)),
                Container(width: 40),
                Text(time,
                    style:
                    TextStyle(fontSize: 10, color: isMe ? Color(0xffEC1B23):Colors.black54)),
                //isMe ? Icon(Icons.done_all, size: 12, color: Color(0xff58B346)) : Container(width: 0, height: 0)
              ],
            )
          ],
        )

      ],
    );
  }


  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      color: Colors.white,
      child: Form(
        key: formkey,
        child: Stack(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // IconButton(
                //    icon: Icon(Icons.attach_file),
                //    iconSize: 25,
                //    color: color,
                //    onPressed: () {
                //      showModalBottomSheet(
                //          backgroundColor:
                //          Colors.transparent,
                //          context: context,
                //          builder: (context) =>
                //              bottomSheet(context));
                //    },
                //  ),
                Expanded(
                  child: TextFormField(
                    controller: sendtextEditingController,
                    cursorColor: Colors.red,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Text area not be blank";
                      }
                      return null;
                    }),
                    decoration: InputDecoration.collapsed(
                      hintText: "Type something....",
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 25,
                  color: Colors.red,
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      var Sendmsg = sendtextEditingController.text;
                      sendMessage(token,args[0], Sendmsg);
                    }

                  },
                ),
                Container(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
