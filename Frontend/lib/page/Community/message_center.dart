import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class message_center extends StatefulWidget {
  const message_center({super.key});

  @override
  _message_centerState createState() => _message_centerState();
}

class _message_centerState extends State<message_center>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      CircleAvatar(),
                    ],
                  ),
                ),
              ),
              // 콘텐츠 부분
              Expanded(
                flex: 8,
                child: Container(),
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
                    _buildButton(3, Icons.account_circle, "계정", false, '/'),
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
                                backgroundImage: NetworkImage(
                                    'https://img2.sbs.co.kr/img/sbs_cms/VD/2014/10/13/VD19790540_w640_h360.jpg'),
                              ),
                              Container(height: 4),
                              Text(
                                "Test님",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Test%Test.com")
                            ],
                          )),
                      //=======================프로필 나타내는 구간 끝========================
                      //=======================버튼 나타내튼 구간========================
                      //=======================지도========================
                      Container(height: 20),
                      SizedBox(
                        width: 230, // 텍스트보다 큰 부모 위젯
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
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
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
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
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
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
    );
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
}
