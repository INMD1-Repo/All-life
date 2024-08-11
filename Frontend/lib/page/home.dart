import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //앱 바는 구현 안
      // appBar: AppBar(title: Text('테스트 구현 페이')),
      body: Column(
        children: [
          //메뉴바 관련 코드임
          Container(
            margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
            decoration: BoxDecoration(
              //컬러는 나중에 수정 예정 레이아웃 작성
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          //콘텐츠 부분
          Container(

          ),
          //하단 메뉴 부
          Container(

          )
        ],
      )
    );
  }
}
