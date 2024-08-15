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
      body: SafeArea( // SafeArea로 화면 영역 보호
        child: Container(
          color: Color(0xfffafafa),
          child: Column(
            children: [
              // 메뉴바 관련 코드
              Expanded(
                flex: 1, // 20%
                child:Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 10 ,15),
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
                    ]
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

                      ),
                    ],
                  ),
                ),
              ),
              // 콘텐츠 부분
              Expanded(
                flex: 8,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SingleChildScrollView( // Make the content scrollable
                      child: Column(
                        children: [
                          // 가벼운 인사말 정도로?
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "반갑습니다.",
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "현재 있는 위치는 XXX동입니다.",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // 현재 지역에 있는 지진 대피 시설 안내
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("지진 대피 시설",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                Padding(padding: EdgeInsets.all(20),
                                    child:  Container(

                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color(0xfff6f6f6)
                                      ),
                                      child: Center(
                                        child: Text("서비스 준비중입니다."),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                          // 현재 지역에 있는 해일 대피 시설 안내
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("해일 대피 시설",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                Padding(padding: EdgeInsets.all(20),
                                    child:  Container(
                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color(0xfff6f6f6)
                                      ),
                                      child: Center(
                                        child: Text("서비스 준비중입니다."),
                                      ),
                                    )
                                  )
                              ],
                            ),
                          ),
                          // 현재 지역에 있는 기타 대피 시설 안내
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("기타 대피 시설",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                Padding(padding: EdgeInsets.all(20),
                                    child:  Container(
                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color(0xfff6f6f6)
                                      ),
                                      child: Center(
                                        child: Text("서비스 준비중입니다."),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                          // 아래에는 슬라읃 형식으로 정부에서 배포한 포스트 올리기
                          Container(
                            margin: EdgeInsets.only(top: 10 ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "재난안전별 행동요령",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        width: MediaQuery.of(context).size.width * 0.23,
                                        child: FloatingActionButton(
                                          onPressed: () {},
                                          child: Text("태풍"),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        width: MediaQuery.of(context).size.width * 0.23,
                                        child: FloatingActionButton(
                                          onPressed: () {},
                                          child: Text("지진"),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        width: MediaQuery.of(context).size.width * 0.23,
                                        child: FloatingActionButton(
                                          onPressed: () {},
                                          child: Text("해일"),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        width: MediaQuery.of(context).size.width * 0.23,
                                        child: FloatingActionButton(
                                          onPressed: () {},
                                          child: Text("화재"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                               Center(
                                 child:  Text("해당 버튼을 누루면 이동합니다.", textAlign:TextAlign.center,
                                 style: TextStyle(fontSize: 10),)
                               )
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
                height: 90,
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
                    _buildButton(0, Icons.home, "홈"),
                    _buildButton(1, Icons.place, "지도 보기"),
                    _buildButton(2, Icons.settings, "설정"),
                    _buildButton(3, Icons.account_circle, "계정"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 버튼을 생성하는 메서드
  Widget _buildButton(int index, IconData icon, String label) {
    return Padding(
      padding: EdgeInsets.only(top: 10), // 여백 조정
      child: TextButton(
        onPressed: () => _onButtonPressed(index),
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent, // 눌림 효과 제거
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 아이콘과 텍스트의 크기 조정
          children: [
            Icon(
              icon,
              color: _selectedIndex == index ? Colors.blue : Colors.black,
            ),
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}