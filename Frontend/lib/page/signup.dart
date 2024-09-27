import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {  // 클래스 이름을 대문자로 수정
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with WidgetsBindingObserver {
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
  String selectedLanguage = '한국어';  // 기본 언어 설정

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
              color: const Color(0xfffEEF7FF),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Please Sign Up",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Text("ID",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ID',
                          )),
                      const SizedBox(height: 15),
                      const Text("Password",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          )),
                      const SizedBox(height: 15),
                      const Text("Password Retry",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password Retry',
                          )),
                      const SizedBox(height: 15),
                      const Text("UserName",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'UserName',
                          )),
                      const SizedBox(height: 15),

                      // 외국어 선택 드롭다운
                      const Text("사용 언어 선택",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedLanguage,
                        items: <String>['한국어', 'English', '日本語', '中文', 'Français', 'Español'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // 개인정보 수집 안내 문구
                      const Text(
                        "개인정보 수집 및 이용에 대한 안내:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "서비스 이용을 위해서는 개인정보 수집에 대한 동의가 필요합니다. "
                            "제공하신 개인정보는 회원가입 및 서비스 제공 목적으로만 사용되며, "
                            "동의 없이 제3자에게 제공되지 않습니다.",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),

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
                          const Text("개인정보 수집에 동의합니다.")
                        ],
                      ),
                      const SizedBox(height: 15),

                      // 사용자 타입 선택 (일반/공인)
                      const Text("사용자 타입",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 20),

                      // Sign Up 버튼
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
                                  title: const Text('동의 필요'),
                                  content:
                                  const Text('개인정보 수집에 동의해야 합니다.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Sign Up"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(350, 60),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
