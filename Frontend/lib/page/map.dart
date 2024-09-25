import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  _mapPageState createState() => _mapPageState();
}

class StarRating extends StatelessWidget {
  final double rating;
  final int totalStars;

  const StarRating({Key? key, required this.rating, this.totalStars = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        if (index < rating.floor()) {
          // 채워진 별 (Full star)
          return const Icon(
            Icons.star,
            color: Colors.amber,
          );
        } else if (index < rating && rating - index > 0.5) {
          // 반 별 (Half star)
          return const Icon(
            Icons.star_half,
            color: Colors.amber,
          );
        } else {
          // 빈 별 (Empty star)
          return const Icon(
            Icons.star_border,
            color: Colors.amber,
          );
        }
      }),
    );
  }
}

class _mapPageState extends State<mapPage> with WidgetsBindingObserver {
  String? earthquake;
  String? tsunami;
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
  NaverMapController? _mapController; // NaverMapController 선언

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

  //유동성을 위한 함수
  void _toggleContainer(allw) {
    setState(() {
      _showContainer = allw; // 조건 반전
    });
  }

  @override
  void initState() {
    super.initState();
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
      loadStorage();
    }
  }

  //-----------데이터 불려오는 함수----------------------------
  Future<void> loadStorage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    earthquake = sp.getString("earthquake_json");
    tsunami = sp.getString("tsunami");
    String userinfo_sp = sp.getString("loginInfo")!;
    userinfo = jsonDecode(userinfo_sp);
    print(userinfo_sp);
  }

  //GPS관련 세팅
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Future<void> _moveCamera() async {
    if (_mapController != null) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings);
        final cameraUpdate = NCameraUpdate.withParams(
          target: NLatLng(position.latitude, position.longitude),
          bearing: 180,
        );
        await _mapController!.updateCamera(cameraUpdate);
      } catch (e) {
        print('카메라 이동 중 오류 발생: $e');
      }
    } else {
      print('MapController가 초기화되지 않았습니다.');
    }
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

  //-----------마커 눌루면 정보 불려오는 함수--------------------------
  String _page_data = "";

  void _page_data_item(allw) {
    _page_data = allw;

    setState(() {
      _page_data = allw; // 조건 반전
    });
  }

  //-----------마커 눌루면 정보 불려오는 함수 끝--------------------------

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          context.go("/");
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
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
                            ),
                            onMapTapped: (point, latLng) {
                              _toggleContainer(false);
                            },
                            onMapReady: (controller) async {
                              _mapController = controller; // 컨트롤러 초기화
                              //GPS 모듈 관련
                              Position position =
                                  await Geolocator.getCurrentPosition(
                                      locationSettings: locationSettings);
                              final cameraUpdate = NCameraUpdate.withParams(
                                target: NLatLng(
                                    position.latitude, position.longitude),
                                zoomBy: 0.4,
                                bearing: 0,
                              );
                              // GPS 카메라 업데이트
                              controller.updateCamera(cameraUpdate);

                              // 자기 위치 핀 추가
                              controller.addOverlay(NMarker(
                                id: "1",
                                position: NLatLng(
                                    position.latitude, position.longitude),
                                icon: NOverlayImage.fromAssetImage(
                                    'assets/my-location.png'),
                                size: Size(24, 24),
                              ));

                              // 지진 핀 추가
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
                                final marker = NMarker(
                                  id: count.toString(),
                                  position: position,
                                  icon: NOverlayImage.fromAssetImage(iconPath),
                                  size: Size(24, 24),
                                );
                                marker.setOnTapListener((NMarker marker) {
                                  print(item);
                                  _toggleContainer(true);
                                  _page_data_item(jsonEncode(item));
                                });
                                controller.addOverlay(marker);
                              }

                              // 쓰나미 핀 추가
                              List<dynamic> tsunamid = jsonDecode(tsunami!);
                              for (var item in tsunamid) {
                                String iconPath = await selectedImage(
                                    item["attributes"]['rating'], "tsunami");
                                count++;
                                NLatLng position = NLatLng(
                                  double.parse(item["attributes"]['ycord']),
                                  double.parse(item["attributes"]['xcord']),
                                );
                                final marker = NMarker(
                                  id: count.toString(),
                                  position: position,
                                  icon: NOverlayImage.fromAssetImage(iconPath),
                                  size: Size(24, 24),
                                );
                                marker.setOnTapListener((NMarker marker) {
                                  _toggleContainer(true);
                                  _page_data_item(jsonEncode(item));
                                });
                                controller.addOverlay(marker);
                              }
                            },
                          ),
                          // 상단 고정바
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.02,
                            child: Container(
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
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.menu, color: Colors.grey),
                                    onPressed: () {
                                      _scaffoldKey.currentState?.openDrawer();
                                      print("Menu clicked");
                                    },
                                  ),
                                  Text(
                                    'ALL LIFE',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                  ),
                                  CircleAvatar(),
                                ],
                              ),
                            ),
                          ),
                          // 지도 위 오버레이
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      right: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
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
                                              color: Color(0xffFCCD2A),
                                              child: InkWell(
                                                splashColor: Color(0xffFCCD2A),
                                                onTap: () {
                                                  context.go(
                                                      "/community/message_center");
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "안전문자",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                    Text(
                                                      "조회",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        FloatingActionButton(
                                          onPressed: _moveCamera,
                                          child: Icon(Icons.my_location),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_showContainer == true)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: _build_page(),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 하단 메뉴 부분
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
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
                        _buildButton(2, Icons.diversity_3, "커뮤니티", false,
                            '/community/reivew'),
                        _buildButton(3, Icons.account_circle, "계정", false, '/'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userinfo["username"],
                                            style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(userinfo["email"]),
                                        ],
                                      ),
                                      if (userinfo["login"] == 0) TextButton(onPressed: () => context.go(""), child: Text("로그인/회원가입", style: TextStyle(color: Colors.white),), style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blue) )) else SizedBox()
                                    ],)
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

  Widget _build_page() {
    Map<String, dynamic> userMap = jsonDecode(_page_data);
    double rating_text = userMap["attributes"]['rating'].toDouble();
    String type = "";
    if (userMap["attributes"]['Type'] == "001") {
      type = "지진대피소";
    } else {
      type = "해일대피소";
    }
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("현재 선택하신 장소 정보",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Container(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Image.asset(
                        "assets/map_test_map.jpg",
                        height: 150,
                      ),
                    )),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    // 패딩 수정 (상단 20 제거)
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start, // 상단 정렬
                        children: [
                          Text(userMap["attributes"]['vt_acmdfclty_nm'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          Text(userMap["attributes"]['dtl_adres'],
                              style: TextStyle(fontSize: 15)),

                          Text("분류: " + type, style: TextStyle(fontSize: 10)),
                          Text("평점", style: TextStyle(fontSize: 13)),
                          //별점 표시
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // 세로 중앙 정렬
                            children: [
                              StarRating(rating: rating_text),
                              Container(width: 70),
                              Text(
                                rating_text.toString(),
                                style: TextStyle(fontSize: 16),
                              ) // 별점 표시
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              if (userinfo['login'] == 0) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      title: Column(
                                        children: const [
                                          Text("로그인이 안되어 있습니다",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("아래버튼을 눌려서 로그인을 해주시기 바람니다.")
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              context.go(
                                                  "/community/review_create");
                                            },
                                            child: Text("로그인"))
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text(
                              "장소 평가",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ]),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
