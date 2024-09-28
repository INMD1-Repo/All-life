import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class message_center extends StatefulWidget {
  const message_center({super.key});

  @override
  _message_centerState createState() => _message_centerState();
}

class _message_centerState extends State<message_center>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  List<Map<String, String>> disasterMessages = [
    {
      "title": "부산광역시",
      "date": "2024.09.18",
      "message":
      "오늘 9시 32분 부산지역에 경계경보 발령. 국민 여러분께서는 대피할 준비를 하시고, 어린이와 노약자가 우선 대피할 수 있도록 해주시기 바랍니다.",
    }
  ];

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
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadLocation();
    }
  }

  Future<void> logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> reset = {
      "login": 0,
      "token": "",
      "refreshtoken": "",
      "userimage": "assets/default_avatar.jpg",
      "username": "Guest",
      "email": "Guest@Guest.com",
      "term": "false",
      "type": 2
    };
    sp.setString("loginInfo", jsonEncode(reset));
    context.go("/");
  }

  Future<void> _loadLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //새로 로드함
    String userinfo_sp = sp.getString("loginInfo")!;
    userinfo = jsonDecode(userinfo_sp);
    print(userinfo_sp);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          context.go("/map");
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: Container(
              color: Color(0xfffafafa),
              child: Column(
                children: [
                  // 메뉴바 관련 코드
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 15),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeff3fb),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu, color: Colors.grey),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                          Text(
                            'ALL LIFE',
                            style:
                            TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                          CircleAvatar(),
                        ],
                      ),
                    ),
                  ),
                  // 콘텐츠 부분
                  Expanded(
                    flex: 8,
                    child: DefaultTabController(
                      length: 2,
                      child: Expanded(
                        flex: 8,
                        child: Container(
                          child: Column(
                            children: [
                              TabBar(
                                tabs: [
                                  Tab(
                                      icon: Icon(Icons.notifications_active),
                                      text: "지역 재난(안내) 문자"),
                                  Tab(
                                      icon: Icon(Icons.compass_calibration),
                                      text: "전국 재난(안내) 문자"),
                                ],
                                indicatorColor: Colors.blue, // 선택된 탭의 밑줄 색상
                                labelColor: Colors.black, // 선택된 탭의 텍스트 색상
                                unselectedLabelColor:
                                Colors.grey, // 선택되지 않은 탭의 텍스트 색상
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    Column(
                                      children: [_ADD_list()],
                                    ),
                                    Center(child: Text("Transit Tab")),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 하단 메뉴 부분
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ],
                      color: Color(0xffF4F4F4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton(0, Icons.home, "홈", false, '/'),
                        _buildButton(1, Icons.place, "지도 보기", false, '/map'),
                        _buildButton(2, Icons.diversity_3, "커뮤니티", true,
                            '/community/reivew'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 100,
                    ),
                  ),
                  // 프로필 및 기타 코드 생략...
                ],
              ),
            ),
          ),
        ));
  }

  // 버튼을 생성하는 메서드
  Widget _buildButton(
      int index, IconData icon, String label, bool change, String Page) {
    return Padding(
      padding: EdgeInsets.only(top: 10), // 여백 조정
      child: TextButton(
        onPressed: () => context.go(Page),
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent, // 눌림 효과 제거
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 아이콘과 텍스트의 크기 조정
          children: [
            Icon(
              icon,
              color: change == true ? Colors.blue : Colors.black,
            ),
            Text(
              label,
              style: TextStyle(
                color: change == true ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 재난 문자 수신용
  _ADD_list() {
    List<Widget> children = [];
    try {
      for (var msg in disasterMessages) {
        children.add(
          Column(
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: const BoxDecoration(
                  color: Color(0xffE1E8ED),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: Container(
                              color: Colors.yellow,
                              child: Icon(Icons.warning, color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg["title"]!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      msg["date"]!,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      disasterMessages.add({
                                        "title": "Busan Metropolitan",
                                        "date": "2024.09.18",
                                        "message":
                                        "[Busan Metropolitan City] Alert issued for Busan area at 9:32 today. Please prepare to evacuate and allow children and the elderly to evacuate first."
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.translate),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          msg["message"]!,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return Expanded(
      child: ListView(
        children: children,
      ),
    );
  }
}
