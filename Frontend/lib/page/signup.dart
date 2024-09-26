import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> with WidgetsBindingObserver {
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

  bool isAgreed = false;  // 개인정보 동의 여부 체크박스 상태
  String userType = '일반';  // 사용자 타입 (일반/공인)

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          context.go("/");
        },
        child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
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
                            Text("Please Sign Up",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text("ID", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'ID',
                                )),
                            SizedBox(height: 15),
                            Text("Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                )),
                            SizedBox(height: 15),
                            Text("Password Retry", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password Retry',
                                )),
                            SizedBox(height: 15),
                            Text("UserName", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'UserName',
                                )),
                            SizedBox(height: 20),

                            // 개인정보 동의 체크박스
                            Row(
                              children: [
                                Checkbox(
                                  value: isAgreed,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isAgreed = value!;
                                    });
                                  },
                                ),
                                Text("개인정보 수집에 동의합니다.")
                              ],
                            ),
                            SizedBox(height: 15),

                            // 사용자 타입 선택 (일반/공인)
                            Text("사용자 타입", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: userType,
                              items: <String>['일반', '공인'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  userType = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () {
                                if (isAgreed) {
                                  // 개인정보 동의가 되어 있을 때만 가입 진행
                                  context.go("/signup");
                                } else {
                                  // 동의하지 않은 경우 경고 메시지
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('동의 필요'),
                                        content: Text('개인정보 수집에 동의해야 합니다.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('확인'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text("Sign Up"),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(350, 60),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              )),
        ));
  }
}
