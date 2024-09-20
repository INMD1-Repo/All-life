import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<mapPage> with WidgetsBindingObserver {
  String? test;
  String? earthquake;
  String? tsunami;
  late NLatLng _currentPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showContainer = false; // 조건을 저장하는 변수

  static const platform = MethodChannel('com.deu.hackton.all_life/native');

  //AR코어 실행기 위한 함수
  Future<void> _startFragmentActivity() async {
    try {
      await platform.invokeMethod('startFragmentActivity');
    } on PlatformException catch (e) {
      print("Fragment Activity를 시작하는 중 오류 발생: ${e.message}");
    }
  }

  void _toggleContainer() {
    setState(() {
      _showContainer = !_showContainer; // 조건 반전
    });
  }

  @override
  void initState() {
    super.initState();
    nowgps();
    loadStorage();
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
      nowgps();
      loadStorage();
    }
  }

  //-----------데이터 불려오는 함수----------------------------
  Future<void> loadStorage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    earthquake = sp.getString("earthquake_json");
    tsunami = sp.getString("tsunami");
  }

  Future<void> nowgps() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final String? lat = sp.getString("Latitude");
    final String? long = sp.getString("Longitude");

    setState(() {
      _currentPosition = NLatLng(double.parse(lat!), double.parse(long!));
    });
  }

  //-----------데이터 불려오는 함수 끝--------------------------

  //-----------마커 이미지 불려오는 함수--------------------------
  Future<String> selectedImage(rating, type) async {
    String basePath = type == "earthquake"
        ? "assets/mapicon/earthquake"
        : "assets/mapicon/tsunami";
    if (rating == 0) {
      return basePath + "0.png";
    } else if (rating < 1) {
      return basePath + "1.png";
    } else if (rating > 2 && rating < 3) {
      return basePath + "2.png";
    } else if (rating < 4) {
      return basePath + "4.png";
    } else {
      return basePath + "0.png";
    }
  }
  //-----------마커 이미지 불려오는 끝--------------------------

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
              // 메뉴바, 콘텐츠 부분
              Expanded(
                  flex: 9,
                  child: Container(
                    child: Stack(
                      children: [
                        // 네이버 지도 표시 부분
                        NaverMap(
                          options: NaverMapViewOptions(
                            locationButtonEnable: false,
                            initialCameraPosition: NCameraPosition(
                              target: _currentPosition ??
                                  NLatLng(37.5666102, 126.9783881),
                              zoom: 13,
                            ),
                          ),
                          onMapReady: (controller) async {
                            print("네이버 맵 로딩됨!");
                            controller.addOverlay(NMarker(
                              id: "1",
                              position: _currentPosition,
                              icon: NOverlayImage.fromAssetImage(
                                  'assets/my-location.png'),
                              size: Size(24, 24),
                            ));

                            var markerData = jsonDecode(earthquake!);
                            markerData = markerData["data"];
                            var count = 1;
                            for (var item in markerData) {
                              String iconPath = await selectedImage(
                                  item["attributes"]['rating'], "earthquake");
                              count++;
                              NLatLng position = NLatLng(
                                double.parse(item["attributes"]['ycord']),
                                double.parse(item["attributes"]['xcord']),
                              );
                              controller.addOverlay(NMarker(
                                id: count.toString(),
                                position: position,
                                icon: NOverlayImage.fromAssetImage(iconPath),
                                size: Size(24, 24),
                              ));
                            }

                            List<dynamic> tsunamid = jsonDecode(tsunami!);
                            for (var item in tsunamid) {
                              String iconPath = await selectedImage(
                                  item["attributes"]['rating'], "tsunami");
                              count++;
                              NLatLng position = NLatLng(
                                double.parse(item["attributes"]['ycord']),
                                double.parse(item["attributes"]['xcord']),
                              );
                              controller.addOverlay(NMarker(
                                id: count.toString(),
                                position: position,
                                icon: NOverlayImage.fromAssetImage(iconPath),
                                size: Size(24, 24),
                              ));
                            }
                          },
                        ),
                        // 상단에 고정된 Container
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
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
                                    print("눌려짐");
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
                        // 네이버 지도 위에 오버로 나타내는 부분
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 20, 10),
                                  child: Column(
                                    children: [
                                      SizedBox.fromSize(
                                        size: Size(60, 60),
                                        child: ClipOval(
                                          child: Material(
                                            color: Colors.orange,
                                            child: InkWell(
                                              splashColor: Colors.green,
                                              onTap: () {
                                                _startFragmentActivity();
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.location_on),
                                                  Text("AR모드"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox.fromSize(
                                        size: Size(60, 60),
                                        child: ClipOval(
                                          child: Material(
                                            color: Colors.red,
                                            child: InkWell(
                                              splashColor: Colors.red,
                                              onTap: () {},
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("재난문자",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text("조회",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      FloatingActionButton(
                                        onPressed: () {
                                          // 의문이지만 작동 안됨
                                        },
                                        child: Icon(Icons.my_location),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_showContainer)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30),
                                      ),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text("asdasd"),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
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
                    _buildButton(1, Icons.place, "지도 보기", true, '/map'),
                    _buildButton(2, Icons.diversity_3, "커뮤니티", false, '/'),
                    _buildButton(3, Icons.account_circle, "계정", false, '/'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),      //윈쪽 메뉴 공개합니다
      drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [            //빈공간
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
                                    backgroundImage: NetworkImage('https://img2.sbs.co.kr/img/sbs_cms/VD/2014/10/13/VD19790540_w640_h360.jpg'),
                                  ),
                                  Container(height: 4),
                                  Text("Test님", style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text("Test%Test.com")
                                ],
                              )

                          ),
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
                              label: const Text('지도보기', style: TextStyle(fontWeight: FontWeight.bold),),
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
                              onPressed: () {},
                              icon: const Icon(Icons.warning),
                              label: const Text('재난문자 보기', style: TextStyle(fontWeight: FontWeight.bold),),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft, // 왼쪽 정렬
                              ),
                            ),
                          ),
                          Container(height: 5),
                          SizedBox(
                            width: double.infinity * 0.3,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.book),
                              label: const Text('대피소 리뷰보기', style: TextStyle(fontWeight: FontWeight.bold),),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft, // 왼쪽 정렬
                              ),
                            ),
                          ),
                          Container(height: 5),
                          SizedBox(
                            width: double.infinity * 0.3,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                              label: const Text('리뷰 수정및 작성하기', style: TextStyle(fontWeight: FontWeight.bold),),
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
                              label: const Text('마이프로필', style: TextStyle(fontWeight: FontWeight.bold),),
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
          )
      )
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
