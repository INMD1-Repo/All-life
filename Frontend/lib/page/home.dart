import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 현재 선택된 버튼을 추적하는 변수
  int _selectedIndex = 0;

  // 버튼을 클릭했을 때 호출되는 메서드
  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 메뉴바 관련 코드
          Expanded(
            flex: 1, // 20%
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 20, 8, 15),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
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
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(0, Icons.home, "홈"),
                    _buildButton(1, Icons.place, "지도 보기"),
                    _buildButton(2, Icons.settings, "설정"),
                    _buildButton(3, Icons.account_circle, "계정"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 버튼을 생성하는 메서드
  Widget _buildButton(int index, IconData icon, String label) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: TextButton(
        onPressed: () => _onButtonPressed(index),
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent, // 눌림 효과 제거
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: _selectedIndex == index ? Colors.blue : Colors.black, // 선택된 버튼이면 파란색, 아니면 검은색
            ),
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index ? Colors.blue : Colors.black, // 선택된 버튼이면 파란색, 아니면 검은색
              ),
            ),
          ],
        ),
      ),
    );
  }
}
