
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<mapPage>  with WidgetsBindingObserver  {
  late NLatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    nowgps();
    WidgetsBinding.instance.addObserver(this);
  }

  //메모리 누수 방지
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      nowgps();
    }
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
                  child: Stack(
                    children: [
                      NaverMap(
                        options: NaverMapViewOptions(
                            initialCameraPosition: NCameraPosition(
                                target: _currentPosition ?? NLatLng(37.5666102, 126.9783881),
                                zoom: 15
                            )
                        ),
                        onMapReady: (controller) {
                          print("네이버 맵 로딩됨!");
                          controller.addOverlay( NMarker(id: "1", position: _currentPosition));

                          },
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Column(
                          children: [
                            SizedBox.fromSize(
                              size: Size(70, 70), // button width and height
                              child: ClipOval(
                                child: Material(
                                  color: Colors.orange, // button color
                                  child: InkWell(
                                    splashColor: Colors.green, // splash color
                                    onTap: () {}, // button pressed
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.location_on), // icon
                                        Text("AR모드"), // text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 20
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                //의문이지만 작동 안됨
                                NCameraUpdate.withParams(
                                    target: _currentPosition ?? NLatLng(37.5666102, 126.9783881),
                                    zoom: 15
                                );
                              },
                              child: Icon(Icons.my_location),
                            )
                          ],
                        )
                        )
                    ],
                  )
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
                    _buildButton(0, Icons.home, "홈", false, '/'),
                    _buildButton(1, Icons.place, "지도 보기", true, '/map'),
                    _buildButton(2, Icons.settings, "설정", false, '/'),
                    _buildButton(3, Icons.account_circle, "계정", false, '/'),
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
  Widget _buildButton(int index, IconData icon, String label, bool change, String Page) {
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
