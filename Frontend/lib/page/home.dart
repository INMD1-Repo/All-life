import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String? test;
  String? earthquake;
  String? tsunami;
  String? default_card;
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    print(userinfo_sp);
    String? data = await sp.getString("locationjson");
    String city =
        jsonDecode(data!)["results"][0]["region"]["area2"]["name"].toString();
    String dong =
        jsonDecode(data!)["results"][0]["region"]["area3"]["name"].toString();
    //자체제작한 API에서 가지고 대피소 정보를 가지고옴
    final Url = Uri.parse(
        'http://hackton.powerinmd.com/api/earthquake-shelters?filters[dtl_adres][\$contains]=$city $dong');
    final req = await http.get(Url);
    earthquake = req.body;
    sp.setString("earthquake_json", req.body);

    //자체제작한 API에서 가지고 대피소 정보를 가지고옴
    final Url_s = Uri.parse(
        "http://hackton.powerinmd.com/api/tsunami-evacuations?filters[address][\$contains]=$city $dong");
    final req_s = await http.get(Url_s);
    tsunami = req_s.body;
    sp.setString("tsunami_shelter", req_s.body);
    //최신자료 반영
    if (city == "김해시" && dong == "내동") {
      dong = "내외동";
    } else if (city == "김해시" && dong == "구산동") {
      dong = "북부동";
    }
    //자체제작한 API에서 가지고 대피소 정보를 가지고옴
    final Url_d = Uri.parse(
        "http://hackton.powerinmd.com/api/cooling-centers/?filters[areaNm][\$contains]=$city $dong");
    final req_d = await http.get(Url_d);
    default_card = req_d.body;
    sp.setString("default_card", req_s.body);

    _list_card();
    setState(() {
      test = city + " " + dong;
    });
  }

  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {},
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
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: SingleChildScrollView(
                          // Make the content scrollable
                          child: Column(
                            children: [
                              // 가벼운 인사말 정도로?
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "반갑습니다.",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '현재 있는 위치는 $test 입니다.',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
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
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        child: Text(
                                          "지진 대피 시설",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      width: double.infinity,
                                      height: 150,
                                      child: Center(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [_list_card()],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 현재 지역에 있는 해일 대피 시설 안내
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "쉼터 정보",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 150,
                                      child: Center(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [_list_sea_card()],
                                          ),
                                        ),
                                      ),
                                    ),
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
                                    Text(
                                      "기타 대피 시설",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 150,
                                      child: Center(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [_list_default_card()],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 아래에는 슬라읃 형식으로 정부에서 배포한 포스트 올리기
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "재난안전별 행동요령",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 100,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(left: 8.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: TextButton(
                                              onPressed: () {
                                                launchUrl(Uri.parse(
                                                    "https://www.korea.kr/multi/visualNewsView.do?newsId=148930976&pwise=mMain&pWiseMain=G4_2#visualNews"));
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.tornado),
                                                  Text("태풍/호우")
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 8.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: TextButton(
                                              onPressed: () {
                                                launchUrl(
                                                  Uri.parse(
                                                      'https://www.mois.go.kr/cmm/fms/getImage.do?atchFileId=FILE_00127937QRD4_FS&fileSn=0&preView=ok'),
                                                );
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.draw),
                                                  Text("지진/해일")
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 8.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.23,
                                            child: TextButton(
                                              onPressed: () {
                                                launchUrl(
                                                  Uri.parse(
                                                      'https://opengov.seoul.go.kr/mediahub/22105241'),
                                                );
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons
                                                      .local_fire_department),
                                                  Text("화재")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                        _buildButton(0, Icons.home, "홈", true, '/'),
                        _buildButton(1, Icons.place, "지도 보기", false, '/map'),
                        _buildButton(2, Icons.diversity_3, "커뮤니티", false,
                            '/community/reivew'),
                        _buildButton(3, Icons.account_circle, "계정", false,
                            '/community/review_create'),
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
                                  Text(
                                    userinfo["username"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(userinfo["email"])
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

  @override
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

  //리스트 만들어주는 메서드 지진대피시설
  _list_card() {
    //사진 파일 선언
    String filepath = 'assets/cardinsert/default.png';

    Row row = Row(children: []);
    try {
      var json = jsonDecode(earthquake!);
      json = json["data"];
      if (json.length == 0 || json.length! == null) {
        row.children.add(Container(
          width: 350,
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xfff6f6f6)),
          child: Center(
            child: Text("조회된 내용이 없습니다."),
          ),
        ));
        return row;
      }
      for (int i = 0; i < json.length; i++) {
        //장소에 따라 이미지가 다르게 설정
        if (json[i]["attributes"]["acmdfclty_se_nm"] == "공원") {
          filepath = 'assets/cardinsert/city.png';
        } else if (json[i]["attributes"]["acmdfclty_se_nm"] == "공설(종합)운동장") {
          filepath = 'assets/cardinsert/park.png';
        } else {
          filepath = 'assets/cardinsert/default.jpg';
        }

        row.children.add(Container(
          width: 350,
          height: 150,
          child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.asset(filepath,
                      fit: BoxFit.cover, width: double.infinity, height: 60),
                  ListTile(
                    title: Text(
                        json[i]["attributes"]["vt_acmdfclty_nm"].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle:
                        Text(json[i]["attributes"]["dtl_adres"].toString()),
                  )
                ],
              )),
        ));
      }
      return row;
    } catch (error) {
      row.children.add(Container(
        width: 350,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xfff6f6f6)),
        child: Center(
          child: Text("서비스를 지원하지 않는 지역입니다.."),
        ),
      ));
      return row;
    }
  }

  //리스트 만들어주는 메서드 해일대피시설
  _list_sea_card() {
    String filepath = 'assets/cardinsert/default.png';
    Row row = Row(children: []);
    try {
      var json = jsonDecode(tsunami!);
      json = json["data"];
      if (json.length == 0 || json.length! == null) {
        row.children.add(Container(
          width: 350,
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xfff6f6f6)),
          child: Center(
            child: Text("조회된 내용이 없습니다."),
          ),
        ));
        return row;
      }
      for (int i = 0; i < json.length; i++) {
        //장소에 따라 이미지가 다르게 설정
        if (json[i]["attributes"]["acmdfclty_se_nm"] == "공원") {
          filepath = 'assets/cardinsert/city.png';
        } else if (json[i]["attributes"]["acmdfclty_se_nm"] == "공설(종합)운동장") {
          filepath = 'assets/cardinsert/park.png';
        } else {
          filepath = 'assets/cardinsert/default.jpg';
        }
        row.children.add(Container(
          width: 350,
          height: 150,
          child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.asset(filepath,
                      fit: BoxFit.cover, width: double.infinity, height: 60),
                  ListTile(
                    title: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        json[i]["attributes"]["vt_acmdfclty_nm"].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        json[i]["attributes"]["dtl_adres"].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              )),
        ));
      }
      return row;
    } catch (error) {
      row.children.add(Container(
        width: 350,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xfff6f6f6)),
        child: Center(
          child: Text("서비스를 지원하지 않는 지역입니다.."),
        ),
      ));
      return row;
    }
  }

  //리스트 만들어주는 메서드 기타 대피 시설
  _list_default_card() {
    String filepath = 'assets/cardinsert/default.png';
    List<Widget> children = []; // Row의 children을 List로 변경
    String cooling = "가능✅";
    String cold = "불가능❌";

    try {
      var json = jsonDecode(default_card!)["data"];

      if (json.isEmpty) {
        children.add(Container(
          width: 350,
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xfff6f6f6)),
          child: Center(
            child: Text("조회된 내용이 없습니다."),
          ),
        ));
        return Row(children: children); // Row로 감싸서 반환
      }

      for (int i = 0; i < json.length; i++) {
        if (json[i]["attributes"]["acmdfclty_se_nm"] == "공원") {
          filepath = 'assets/cardinsert/city.png';
        } else if (json[i]["attributes"]["acmdfclty_se_nm"] == "공설(종합)운동장") {
          filepath = 'assets/cardinsert/park.png';
        } else {
          filepath = 'assets/cardinsert/default.jpg';
        }
        //장소 이용가능 여부
        if (json[i]["attributes"]["cold_wave"] == "Y") {
          cold = "이용가능 ✅";
        }
        if (json[i]["attributes"]["cooling"] == "N") {
          cooling = "불가능❌";
        }
        // 카드 추가
        children.add(Container(
          width: 350,
          height: 150,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Image.asset(filepath,
                    fit: BoxFit.cover, width: double.infinity, height: 60),
                Expanded(
                  // Expanded로 Row의 공간을 차지하게
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // 위젯 배치를 조정
                    children: [
                      Expanded(
                        flex: 3, // ListTile이 공간을 차지하도록 설정
                        child: ListTile(
                          title: Text(
                              json[i]["attributes"]["restname"].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            json[i]["attributes"]["restaddr"].toString(),
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "쉼터 여부",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "무더위 쉼터: " + cooling,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "한파 쉼터: " + cold,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      }

      return Row(children: children); // Row로 감싸서 반환
    } catch (error) {
      children.add(Container(
        width: 360,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xfff6f6f6)),
        child: Center(
          child: Text("서비스를 지원하지 않는 지역입니다.."),
        ),
      ));
      return Row(children: children); // Row로 감싸서 반환
    }
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
}
