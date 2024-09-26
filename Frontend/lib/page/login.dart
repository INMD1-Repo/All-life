import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loguin extends StatefulWidget {
  const loguin({super.key});

  @override
  _loguinState createState() => _loguinState();
}

class _loguinState extends State<loguin> with WidgetsBindingObserver {
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
    _loadLocation();
    WidgetsBinding.instance.addObserver(this);
  }

  //메모리 누수 방지
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadLocation();
    }
  }

  Future<void> _loadLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String userinfo_sp = sp.getString("loginInfo")!;
    userinfo = jsonDecode(userinfo_sp);
    print(userinfo_sp);
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
            // SafeArea로 화면 영역 보호
            child: Container(
              color: Color(0xfffEEF7FF),
              child: Center(
                  child: Container(
                padding: EdgeInsets.all(30),
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),
                    Image.asset(
                      "assets/login_app_logo.png",
                      height: 100,
                      width: 100,
                    ),
                    Text("다시 만나서 반갑습니다.",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text("저희 ALL-LIFE(올라이프)는 대한민국의 재난 대피소를 AR로 보여주는 플랫폼 입니다."),
                    SizedBox(height: 20),
                    TextField(
                        decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Hint',
                    )),
                    SizedBox(height: 20),
                    TextField(
                        decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Hint',
                    ))
                  ],
                ),
              )),
            ),
          ),
          //윈쪽 메뉴 공개합니다
        ));
  }
}
