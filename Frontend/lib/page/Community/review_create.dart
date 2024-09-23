import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

class review_create extends StatefulWidget {
  const review_create({super.key});

  @override
  _review_createtate createState() => _review_createtate();
}

class _review_createtate extends State<review_create>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _rating = 0; // 초기 평점

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
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 0), // 오른쪽 padding 추가
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
                          crossAxisAlignment: CrossAxisAlignment.start, // 상단 정렬
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: Checkbox(value: false, onChanged: null),
                            ),
                            Expanded(
                              child: Text(
                                "수용가능 인원대비 생필품 재고는 충분히 구비되어 있는가?",
                                maxLines: 2, // 최대 두 줄로 제한
                                overflow: TextOverflow.ellipsis, // 글자가 넘치면 생략
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
                          crossAxisAlignment: CrossAxisAlignment.start, // 상단 정렬
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: Checkbox(value: false, onChanged: null),
                            ),
                            Expanded(
                              child: Text(
                                "대피소는 상시 개발을 준수는하고 있는 가?",
                                maxLines: 2, // 최대 두 줄로 제한
                                overflow: TextOverflow.ellipsis, // 글자가 넘치면 생략
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
                          crossAxisAlignment: CrossAxisAlignment.start, // 상단 정렬
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: Checkbox(value: false, onChanged: null),
                            ),
                            Expanded(
                              child: Text(
                                "용도에 맞게 사용되고 있는가?",
                                maxLines: 1, // 최대 두 줄로 제한
                                overflow: TextOverflow.ellipsis, // 글자가 넘치면 생략
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
                          crossAxisAlignment: CrossAxisAlignment.start, // 상단 정렬
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: Checkbox(value: false, onChanged: null),
                            ),
                            Expanded(
                              child: Text(
                                "건물대치자는 대피소의 정확한 위치를 알고 있는가?",
                                maxLines: 2, // 최대 두 줄로 제한
                                overflow: TextOverflow.ellipsis, // 글자가 넘치면 생략
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
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber, // 별 색상
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating; // 별을 선택하면 평점이 업데이트됨
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
                          child: Text("제출", style: TextStyle(color: Colors.white, fontSize: 20),),
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
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
                      _buildButton(3, Icons.account_circle, "계정", false, '/'),
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
