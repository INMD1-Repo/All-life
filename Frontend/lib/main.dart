import 'package:all_life/page/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:all_life/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//주로 실행하는 코드
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  //권한 요청
  await _requestLocationPermission();
  await NaverMapSdk.instance.initialize(
      clientId: "tyjuxvg2v0",
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
  //앱 초기에 위치 가져오기오고 저장하기
  Get_GPS();

  //첫번째 스크린 뛰우다가 지우기
  FlutterNativeSplash.remove();
  runApp(ALLlife());
}

// 위치 권한 요청 함수
Future<void> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
}

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100
);

class ALLlife extends StatefulWidget {
  @override
  _ALLlife createState() => _ALLlife();
}

class _ALLlife extends State<ALLlife> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

 //메모리 누수 방지
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //위챗 상태 나타내줌
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ALL-Life',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router, // GoRouter 라우터 사용
    );
  }

  //사용자에 의해 중지된 앱을 다시 실행하때
  //Latitude: 35.1669385, Longitude: 129.1329491
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      Get_GPS();
    }
  }

  //테스트용 (화면 방향이나 전환 되면 위치 새로드)
  @override void didChangeMetrics() async{
    // TODO: implement didChangeMetrics
    super.didChangeMetrics();
    Get_GPS();
  }
}

void Get_GPS()  async {
  print("GPS 데이터 가져오기 성공");
  SharedPreferences sp = await SharedPreferences.getInstance();
  Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  await sp.setString("Latitude", position.latitude.toString());
  await sp.setString("Longitude", position.longitude.toString());
  final String? lat = sp.getString("Latitude");
  final String? long = sp.getString("Longitude");
  //좌표를 주소로 받아오기
  final Url = Uri.parse("https://nominatim.openstreetmap.org/reverse?lat="+lat!+"&lon="+long!+"&format=json");
  final req = await http.get(Url);

  //json 저장
  await sp.setString("locationjson", req.body);
}


// GoRouter 설정
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      // 초기 경로에 해당하는 페이지
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => mapPage())
    // 추가 경로를 여기에 정의
  ],
  // 경로 오류 시 보여줄 페이지
  errorBuilder: (context, state) => ErrorPage(),
);
class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(child: Text('Page not found')),
    );
  }
}
