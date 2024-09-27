import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class loguin extends StatefulWidget {
  const loguin({super.key});

  @override
  _loguinState createState() => _loguinState();
}

class _loguinState extends State<loguin> with WidgetsBindingObserver {
  String id = "";
  String password = "";

  Map<String, dynamic> userinfo = {
    "login": 0,
    "token": "",
    "refreshtoken": "",
    "userimage": "assets/default_avatar.jpg",
    "username": "Guest",
    "email": "Guest@Guest.com",
    "term": "false",
    "type": 2
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // 메모리 누수 방지
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
    }
  }

  Future<void> _Sinup_in_SharedPreferences() async {
   String bodys = "{\"user_id\":\"$id\",\"password\":\"$password\"}";
   final url = Uri.parse('http://www.ready-order.shop:334/user/signin');
   final headers = {"Content-Type": "application/json"};
   try {
     final response = await http.post(
       url,
       headers: headers,
       body: bodys,
     );

     if (response.statusCode == 201) {
       Map<String, dynamic> data = jsonDecode(response.body);
       Map<String, dynamic> decodedToken = JwtDecoder.decode(data["accessToken"]);
       userinfo =  {
         "login": 1,
         "token": data["accessToken"],
         "refreshtoken": "",
         "userimage": "assets/default_avatar.jpg",
         "username": decodedToken["username"],
         "email": decodedToken["email"],
         "term": decodedToken["term"],
         "type": decodedToken["type"],
         "language": decodedToken["language"],
         "location": decodedToken["location"]
       };
       print(userinfo);
       SharedPreferences sp = await SharedPreferences.getInstance();
       sp.setString("loginInfo", jsonEncode(userinfo));
       context.go("/");
     } else {
       // 요청 실패 처리
       _showBackDialog(true, "로그인에 실패했습니다. 다시 시도해주시기 바람니다.");
     }
   } catch (e) {
     // 에러 처리
     print(e);
     _showBackDialog(true, "로그인에 실패했습니다. 다시 시도해주시기 바람니다.");
   }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        context.go("/");
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Color(0xfffEEF7FF),
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 80),
                          Center(
                            child: Image.asset(
                              "assets/login_app_logo.png",
                              height: 100,
                              width: 100,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "저희 ALL-LIFE(올라이프)는 대한민국의 재난 대피소를 AR로 보여주는 플랫폼 입니다.",
                          ),
                          SizedBox(height: 30),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'ID',
                            ),onChanged: (text) => {
                              id = text
                          },
                          ),
                          SizedBox(height: 30),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '패스워드(Password)',
                            ),onChanged: (text) => {
                            password = text
                          },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _Sinup_in_SharedPreferences();
                        },
                        child: Text("Sign In(로그인)"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Add sign-up navigation
                          context.go("/signup");
                        },
                        child: Text("Create Account(회원가입)"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<bool?> _showBackDialog(type, String message) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        if (type) {
          return AlertDialog(
            title: const Text('오류!'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(context, true); // 다이얼로그 닫기
                },
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
