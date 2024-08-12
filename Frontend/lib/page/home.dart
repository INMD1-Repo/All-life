import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 바는 구현 안 함
      // appBar: AppBar(title: Text('테스트 구현 페이지')),
      body: Column(
        children: [
          // 메뉴바 관련 코드
          Expanded(
            flex: 1, // 20%
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 20, 8, 15),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                // 컬러는 나중에 수정 예정, 레이아웃 작성
                color: Color(0xffeff3fb),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 IconButton(
                   icon: Icon(Icons.menu, color: Colors.grey),
                   onPressed: () {
                     // 메뉴 버튼 클릭 시 실행할 코드
                   },
                 ),
                 Text(
                   'ALL LIFE',
                   style: TextStyle(color: Colors.black, fontSize: 16.0),
                 ),
                 CircleAvatar(
                   backgroundImage: NetworkImage(
                     'https://example.com/profile.jpg', // 여기에 프로필 이미지 URL 입력
                   ),
                 ),
               ],
              ),
            ),
          ),
          // 콘텐츠 부분
          Expanded(
            flex: 8, // 60%
            child: Container(
              color: Colors.blueAccent, // 임시로 배경색 지정 (콘텐츠 영역)
              child: Center(
                child: Text(
                  '콘텐츠 영역',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          // 하단 메뉴 부분
          Expanded(
            flex: 1, // 20%
            child: Container(
              //color: Colors.greenAccent, // 임시로 배경색 지정 (하단 메뉴 영역)
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: TextButton(
                             onPressed: () {},
                            style: TextButton.styleFrom(
                              overlayColor: Colors.transparent, // 눌림 효과 제거
                            ),
                        child: Column(
                          children: [
                            Icon(Icons.home, color: Colors.black),
                            Text("홈", style: TextStyle(color: Colors.black))
                          ],
                        )
                      )
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              overlayColor: Colors.transparent, // 눌림 효과 제거
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.place, color: Colors.black),
                                Text("지도 보기", style: TextStyle(color: Colors.black))
                              ],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              overlayColor: Colors.transparent, // 눌림 효과 제거
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.settings, color: Colors.black),
                                Text("설정", style: TextStyle(color: Colors.black))
                              ],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              overlayColor: Colors.transparent, // 눌림 효과 제거
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.account_circle, color: Colors.black),
                                Text("계정", style: TextStyle(color: Colors.black))
                              ],
                            )
                        )
                    )
                  ],

                )
              ),
            ),
          ),
        ],
      ),
    );
  }
  }