import 'dart:convert';

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

  bool _showContainer = false; // 조건을 저장하는 변수

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Stack(
                  children: [
                    //네이버 지도 표시 부분
                    NaverMap(
                        options: NaverMapViewOptions(
                            locationButtonEnable: false,
                            initialCameraPosition: NCameraPosition(
                                target: _currentPosition ??
                                    NLatLng(37.5666102, 126.9783881),
                                zoom: 13)),
                        onMapReady: (controller) async {
                          print("네이버 맵 로딩됨!");
                          controller.addOverlay(NMarker(
                              id: "1",
                              position: _currentPosition,
                              icon: NOverlayImage.fromAssetImage(
                                  'assets/my-location.png'),
                              size: Size(24, 24)));
                          //지진 부분만 추가
                          List<dynamic> markerData = jsonDecode(earthquake!);
                          var count = 1;
                          for (var item in markerData) {
                            count++;
                            NLatLng position = NLatLng(
                                double.parse(item['ycord']),
                                double.parse(item['xcord']));
                            controller.addOverlay(
                              NMarker(
                                  id: count.toString(),
                                  position: position,
                                  icon: NOverlayImage.fromAssetImage(
                                      'assets/earthquake.png'),
                                  size: Size(24, 24)),
                            );
                          }

                          //지진 부분만 추가
                          List<dynamic> tsunamid = jsonDecode(tsunami!);
                          for (var item in tsunamid) {
                            count++;
                            NLatLng position = NLatLng(
                                double.parse(item['ycord']),
                                double.parse(item['xcord']));
                            controller.addOverlay(
                              NMarker(
                                  id: count.toString(),
                                  position: position,
                                  icon: NOverlayImage.fromAssetImage(
                                      'assets/tsunami.png'),
                                  size: Size(24, 24)),
                            );
                          }
                        }),
                    //네이버 지도 위에 오버로 나타내는 부분
                    Positioned(
                        child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //지도 버튼들
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 20, 10),
                              child: Column(children: [
                                SizedBox.fromSize(
                                  size: Size(70, 70),
                                  // button width and height
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.orange,
                                      // button color
                                      child: InkWell(
                                        splashColor: Colors.green,
                                        // splash color
                                        onTap: () {},
                                        // button pressed
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.location_on),
                                            // icon
                                            Text("AR모드"),
                                            // text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                FloatingActionButton(
                                  onPressed: () {
                                    //의문이지만 작동 안됨
                                  },
                                  child: Icon(Icons.my_location),
                                )
                              ])),
                          //대피소 정보 제공
                          if (_showContainer)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    30,
                                  ),
                                  topLeft: Radius.circular(30),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: TextButton(
                                  onPressed: () {}, child: Text("asdasd")),
                            )
                        ],
                      ),
                    ))
                  ],
                )),
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
                    _buildButton(2, Icons.diversity_3, "커뮤니티", false, '/'),
                    _buildButton(3, Icons.settings, "설정", false, '/'),
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
