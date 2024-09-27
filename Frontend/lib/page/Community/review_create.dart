import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class review_create extends StatefulWidget {
  final Object? extra;

  const review_create({super.key, this.extra});

  @override
  _review_createtate createState() => _review_createtate();
}

class _review_createtate extends State<review_create>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String uuid = "";
  double _rating = 0; // 초기 평점
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

  bool _isCheckquestion1 = false;
  bool _isCheckquestion2 = false;
  bool _isCheckquestion3 = false;
  bool _isCheckquestion4 = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    Post_data(widget.extra);
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

  void Post_data(Object? extra) {
    var Place_id = jsonDecode(extra!.toString());
    uuid = Place_id["place_id"].toString();
  }

  void answer_send() async {
    Map<String, dynamic> body = {
      "question1": _isCheckquestion1 ? "1" : "0",
      "question2": _isCheckquestion2 ? "1" : "0",
      "question3": _isCheckquestion3 ? "1" : "0",
      "question4": _isCheckquestion4 ? "1" : "0",
      "rating": _rating,
      "UserID": userinfo["username"],
      "email": userinfo["email"],
      "place_uuid": uuid
    };

    final url = Uri.parse('https://hackton.powerinmd.com/api/quest-answers');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer 00587b42c3284bf6137d9a0795d81e292f56d3cec953be9828cf25181ba9ef9e70ef3a2dd54526098592479f65e0436c009bd6739be705d40b9a69b5727c052aa462560bedca8c0341841427b1fd382c219cdf0ef9b61f01c2b18445f5a2151ae6e542b80c10cd3c0467daa404e4dfae159bbc40f2f2c8703d2654841fb149cf"
    };

    try {
      // UserID를 조회하는 로직 추가
      final userIdCheckUrl = Uri.parse('https://hackton.powerinmd.com/api/quest-answers?UserID=${userinfo["username"]}');
      final userIdResponse = await http.get(userIdCheckUrl, headers: headers);

      if (userIdResponse.statusCode == 200) {
        final responseData = jsonDecode(userIdResponse.body);
        final existingData = responseData['data'];

        if (existingData.isNotEmpty) {
          // UserID가 존재하는 경우 PUT 요청
          final updateUrl = Uri.parse('https://hackton.powerinmd.com/api/quest-answers/${existingData[0]['id']}'); // ID를 사용하여 업데이트

          final updateResponse = await http.put(
            updateUrl,
            headers: headers,
            body: jsonEncode({"data": body}),
          );

          if (updateResponse.statusCode == 200) {
            _showsnackbars(context);
            context.go("/map");
          } else {
            print(updateResponse.body);
            _showResultErrorDialog(true, "업데이트에 실패했습니다. 다시 시도해주시기 바랍니다.");
          }
        }
      } else if (userIdResponse.statusCode == 404) {
        // UserID가 존재하지 않는 경우 POST 요청
        final response = await http.post(
          url,
          headers: headers,
          body: jsonEncode({"data": body}),
        );

        if (response.statusCode == 200) {
          _showsnackbars(context);
          context.go("/map");
        } else {
          print(response.body);
          _showResultErrorDialog(true, "업로드에 실패했습니다. 다시 시도해주시기 바랍니다.");
        }
      } else {
        // 사용자 조회 실패 처리
        print(userIdResponse.body);
        _showResultErrorDialog(true, "사용자 조회에 실패했습니다. 다시 시도해주시기 바랍니다.");
      }
    } catch (e) {
      // 에러 처리
      print(e);
      _showResultErrorDialog(true, "업로드에 실패했습니다. 다시 시도해주시기 바랍니다.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          final bool shouldPop = await _showBackDialog() ?? false;
          if (context.mounted && shouldPop) {
            context.go("/");
          }
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
                  // 콘텐츠 부분
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding:
                          EdgeInsets.fromLTRB(30, 5, 30, 0), // 오른쪽 padding 추가
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "대피장소 평가",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "본 질문에 만족하지 않는 항목은 체크하지 말아주세요.",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            //----------------선택창 부분-----------------------
                            padding: EdgeInsets.all(10), // 추가적인 padding
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 상단 정렬
                              children: [
                                Transform.scale(
                                  scale: 1.4,
                                  child: Checkbox(
                                    value: _isCheckquestion1,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckquestion1 = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "수용가능 인원대비 생필품 재고는 충분히 구비되어 있는가?",
                                    maxLines: 2, // 최대 두 줄로 제한
                                    overflow:
                                        TextOverflow.ellipsis, // 글자가 넘치면 생략
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10), // 추가적인 padding
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 상단 정렬
                              children: [
                                Transform.scale(
                                  scale: 1.4,
                                  child: Checkbox(
                                    value: _isCheckquestion2,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckquestion2 = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "대피소는 상시 개발을 준수는하고 있는 가?",
                                    maxLines: 2, // 최대 두 줄로 제한
                                    overflow:
                                        TextOverflow.ellipsis, // 글자가 넘치면 생략
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10), // 추가적인 padding
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 상단 정렬
                              children: [
                                Transform.scale(
                                  scale: 1.4,
                                  child: Checkbox(
                                    value: _isCheckquestion3,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckquestion3 = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "용도에 맞게 사용되고 있는가?",
                                    maxLines: 1, // 최대 두 줄로 제한
                                    overflow:
                                        TextOverflow.ellipsis, // 글자가 넘치면 생략
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10), // 추가적인 padding
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 상단 정렬
                              children: [
                                Transform.scale(
                                  scale: 1.4,
                                  child: Checkbox(
                                    value: _isCheckquestion4,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckquestion4 = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "건물대치자는 대피소의 정확한 위치를 알고 있는가?",
                                    maxLines: 2, // 최대 두 줄로 제한
                                    overflow:
                                        TextOverflow.ellipsis, // 글자가 넘치면 생략
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //----------------선택창 부분 끝-----------------------
                          //평점 부분
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("평점  $_rating",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold)),
                                Container(height: 10),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Rating Bar
                                      RatingBar.builder(
                                        initialRating: 0,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        // 반개 별 허용
                                        itemCount: 5,
                                        // 별 개수
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber, // 별 색상
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            _rating =
                                                rating; // 별을 선택하면 평점이 업데이트됨
                                          });
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      // 평점 숫자로 표시
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextButton(
                              child: Text(
                                "제출",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                answer_send();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)))),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // 하단 메뉴 부분
                  Expanded(
                    flex: 1,
                    child: Container(
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
                  )
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

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정말 종료하시겟습니까?'),
          content: const Text(
            '지금 나가면 메인페이지로 이동하며 처음부터 다시해야 합니다.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('아니요'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('예'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showResultErrorDialog(type, String message) {
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

  Future<void> _showsnackbars(BuildContext context) async {
    final snackBar = SnackBar(
      content: Text('정상적으로 제출했습니다.'),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: '확인',
        onPressed: () {
          // 버튼 눌렀을 때의 작업을 여기에 추가하세요.
        },
      ),
    );

    // SnackBar를 화면에 표시합니다.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
