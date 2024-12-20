import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class reivew extends StatefulWidget {
  const reivew({super.key});

  @override
  _reivewState createState() => _reivewState();
}

class StarRating extends StatelessWidget {
  final double rating;
  final int totalStars;

  const StarRating({Key? key, required this.rating, this.totalStars = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        if (index < rating.floor()) {
          // 채워진 별 (Full star)
          return const Icon(
            size: 15,
            Icons.star,
            color: Colors.grey,
          );
        } else if (index < rating && rating - index > 0.5) {
          // 반 별 (Half star)
          return const Icon(
            size: 15,
            Icons.star_half,
            color: Colors.grey,
          );
        } else {
          // 빈 별 (Empty star)
          return const Icon(
            size: 15,
            Icons.star_border,
            color: Colors.grey,
          );
        }
      }),
    );
  }
}

class _reivewState extends State<reivew> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String getreivew = "{\"data\":[{\"id\":4,\"attributes\":{\"question1\":\"0\",\"question2\":\"1\",\"question3\":\"1\",\"question4\":\"1\",\"rating\":3.5,\"UserID\":\"데이터불러오는중\",\"email\":\"lyw514549@gmail.com\",\"createdAt\":\"2024-09-27T15:08:03.562Z\",\"updatedAt\":\"2024-09-27T20:50:30.235Z\",\"publishedAt\":\"2024-09-27T15:08:03.559Z\",\"place_uuid\":\"1165e08e-5f25-4fb6-891c-0082823183d6\",\"place\":\"데이터불러오는중\"}}],\"meta\":{\"pagination\":{\"page\":1,\"pageSize\":25,\"pageCount\":1,\"total\":1}}}";

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

  @override
  void initState() {
    _loadLocation();
    super.initState();
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
    //새로 로드함
    String userinfo_sp = sp.getString("loginInfo")!;
    userinfo = jsonDecode(userinfo_sp);
    final Url = Uri.parse('https://hackton.powerinmd.com/api/quest-answers');
    final headers = {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer 00587b42c3284bf6137d9a0795d81e292f56d3cec953be9828cf25181ba9ef9e70ef3a2dd54526098592479f65e0436c009bd6739be705d40b9a69b5727c052aa462560bedca8c0341841427b1fd382c219cdf0ef9b61f01c2b18445f5a2151ae6e542b80c10cd3c0467daa404e4dfae159bbc40f2f2c8703d2654841fb149cf"
    };
    final userIdResponse = await http.get(Url, headers: headers);
    setState(() {
      getreivew = userIdResponse.body;
    });
    print(getreivew);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          context.go("/");
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            // SafeArea로 화면 영역 보호
            child: Container(
              color: Color(0xfffafafa),
              child: Column(
                children: [
                  // 메뉴바 관련 코드
                  Expanded(
                    flex: 1, // 20%
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
                              // 메뉴 버튼 클릭 시 실행할 코드
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
                  // Content를 보이게 하는 곳
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 2,
                            //간단하게 설명 해주는 쌈엔뽕
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(40, 20, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("전국에 있는",
                                          style: TextStyle(fontSize: 23)),
                                      Text(
                                        "사용자",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23),
                                      ),
                                      Text("들이", style: TextStyle(fontSize: 23))
                                    ],
                                  ),
                                  Text("평가한 자료를 한번 볼까요?",
                                      style: TextStyle(fontSize: 23))
                                ],
                              ),
                            )),
                        Expanded(
                          flex: 11,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              // Set the color here inside the BoxDecoration
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [_ADD_list()],
                              )),
                            ),
                          ),
                        )
                      ],
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
                            '/community/reivew')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //윈쪽 메뉴 공개합니다
          drawer: Drawer(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                //빈공간
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                  ),
                ),
                //메뉴 로그인 요소들
                Expanded(
                    flex: 8,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: [
                          //=======================프로필 나타내는 구간========================
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 48, // Image radius
                                    backgroundImage:
                                        AssetImage(userinfo["userimage"]),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userinfo["username"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(userinfo["email"]),
                                        ],
                                      ),
                                      if (userinfo["login"] == 0)
                                        TextButton(
                                            onPressed: () =>
                                                context.go("/login"),
                                            child: Text(
                                              "로그인/회원가입",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue)))
                                      else
                                        SizedBox(),
                                      if (userinfo["login"] == 1)
                                        TextButton(
                                            onPressed: () {
                                              logout();
                                            },
                                            child: Text(
                                              "로그아웃",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue)))
                                      else
                                        SizedBox()
                                    ],
                                  )
                                ],
                              )),
                          //=======================프로필 나타내는 구간 끝========================
                          //=======================버튼 나타내튼 구간========================
                          //=======================지도========================
                          Container(height: 20),
                          SizedBox(
                            width: 230, // 텍스트보다 큰 부모 위젯
                            child: Align(
                              alignment: Alignment.centerLeft,
                              // 텍스트를 왼쪽으로 정렬
                              child: Text('지도'),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity * 0.3,
                            child: TextButton.icon(
                              onPressed: () => context.go("/map"),
                              icon: const Icon(Icons.map),
                              label: const Text(
                                '지도보기',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft, // 왼쪽 정렬
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey, // 선 색상
                            thickness: 1, // 선 두께
                            indent: 10, // 왼쪽 여백
                            endIndent: 10, // 오른쪽 여백
                          ),
                          //=======================지도 끝========================
                          //=======================커뮤니티========================
                          Container(height: 7),
                          SizedBox(
                            width: 230, // 텍스트보다 큰 부모 위젯
                            child: Align(
                              alignment: Alignment.centerLeft,
                              // 텍스트를 왼쪽으로 정렬
                              child: Text('커뮤니티'),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity * 0.3,
                            child: TextButton.icon(
                              onPressed: () =>
                                  context.go("/community/message_center"),
                              icon: const Icon(Icons.warning),
                              label: const Text(
                                '재난문자 보기',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft, // 왼쪽 정렬
                              ),
                            ),
                          ),
                          Container(height: 5),
                          SizedBox(
                            width: double.infinity * 0.3,
                            child: TextButton.icon(
                              onPressed: () => context.go("/community/reivew"),
                              icon: const Icon(Icons.book),
                              label: const Text(
                                '대피소 리뷰보기',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft, // 왼쪽 정렬
                              ),
                            ),
                          ),
                          Container(height: 5),
                          SizedBox(
                            width: double.infinity * 0.3,
                            child: TextButton.icon(
                              onPressed: () =>
                                  context.go("/community/review_create"),
                              icon: const Icon(Icons.edit),
                              label: const Text(
                                '리뷰 수정및 작성하기',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft, // 왼쪽 정렬
                              ),
                            ),
                          ),
                          Container(height: 5),
                          Divider(
                            color: Colors.grey, // 선 색상
                            thickness: 1, // 선 두께
                            indent: 10, // 왼쪽 여백
                            endIndent: 10, // 오른쪽 여백
                          ),
                          //=======================커뮤니티 끝========================
                          //=======================계정 및 설정 ========================
                          Container(height: 5),
                          SizedBox(
                            width: 230, // 텍스트보다 큰 부모 위젯
                            child: Align(
                              alignment: Alignment.centerLeft,
                              // 텍스트를 왼쪽으로 정렬
                              child: Text('계정 및 설정'),
                            ),
                          ),
                          Container(height: 5),
                          SizedBox(
                            width: double.infinity * 0.3,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.map),
                              label: const Text(
                                '마이프로필',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft, // 왼쪽 정렬
                              ),
                            ),
                          )
                          //=======================계정 및 설정 끝========================
                          //=======================버튼 나타내튼 구간 끝========================
                        ],
                      ),
                    )),
                //빈공간
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                  ),
                )
              ],
            ),
          )),
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

  //리뷰를 불려내기 위한 것
  //추후 로그인 연동시 리스트 불려올수 있도록 조치 할것
  _ADD_list() {
    Map<String, dynamic> userMap = jsonDecode(getreivew);
    List<Widget> children = [];
    try {
      for (int i = 0; i < userMap["data"].length; i++) {
        children.add(Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white, // Move color into BoxDecoration
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              //make border radius more than 50% of square height & width
                              child: Image.asset(
                                "assets/default_avatar.jpg",
                                height: 60.0,
                                width: 60.0,
                                fit: BoxFit.cover, //change image fill type
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userMap["data"][i]["attributes"]["UserID"] ,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "장소:" + userMap["data"][i]["attributes"]["place"],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                StarRating(rating: userMap["data"][i]["attributes"]["rating"].toDouble()),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ExpansionTile(
                          title: Text(
                            "질문 상세 보기",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("[1번째 질문]"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 240,
                                              child: Text(
                                                "수용가능 인원댜비 생필품 재고는 충분히 구비되어 있는가?",
                                                style: TextStyle(fontSize: 12),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Text(userMap["data"][i]["attributes"]["question1"] == "1" ? "✅" : "❌",
                                                style: TextStyle(fontSize: 20)),
                                            SizedBox(width: 10)
                                          ],
                                        ),
                                        SizedBox(height: 10)
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("[2번째 질문]"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 240,
                                              child: Text(
                                                "대피소는 상시 개발을 준수하고 있는가?",
                                                style: TextStyle(fontSize: 12),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Text(userMap["data"][i]["attributes"]["question2"] == "1" ? "✅" : "❌",
                                                style: TextStyle(fontSize: 20)),
                                            SizedBox(width: 10)
                                          ],
                                        ),
                                        SizedBox(height: 10)
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("[3번째 질문]"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 240,
                                              child: Text(
                                                "용도에 맟게 사용되고 있는가?",
                                                style: TextStyle(fontSize: 12),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Text(userMap["data"][i]["attributes"]["question3"] == "1" ?  "✅" : "❌",
                                                style: TextStyle(fontSize: 20)),
                                            SizedBox(width: 10)
                                          ],
                                        ),
                                        SizedBox(height: 10)
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("[4번째 질문]"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 240,
                                              child: Text(
                                                "건물 관리자는 대피소의 정확한 위치를 알고 있는가?",
                                                style: TextStyle(fontSize: 12),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Text(userMap["data"][i]["attributes"]["question4"] == "1" ? "✅" : "❌",
                                                style: TextStyle(fontSize: 20)),
                                            SizedBox(width: 10)
                                          ],
                                        ),
                                        SizedBox(height: 10)
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        SizedBox(height: 10)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
      }

      return Column(children: children);
    } catch (error) {
      // Handle the error by returning a fallback widget
      return Column(
        children: [
          Text('Error occurred while building the list'),
        ],
      );
    }
  }
}
