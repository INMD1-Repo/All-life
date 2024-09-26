import 'dart:convert';

import 'package:all_life/page/Community/message_center.dart';
import 'package:all_life/page/Community/review.dart';
import 'package:all_life/page/Community/review_create.dart';
import 'package:all_life/page/signup.dart';
import 'package:all_life/page/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:all_life/page/home.dart';
import 'package:all_life/page/map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 주로 실행하는 코드
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  // 권한 요청
  await _requestLocationPermission();
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.get('Client_ID'),
    onAuthFailed: (ex) {
      print("********* 네이버맵 인증오류 : $ex *********");
    },
  );

  // 앱 초기에 위치 가져오기 저장하기
  Get_GPS(dotenv.get('Client_ID'), dotenv.get('Client_Secret'));

  // 첫번째 스크린 뛰우다가 지우기
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
  distanceFilter: 100,
);

// GPS 정보 가져오기
void Get_GPS(String Client_ID, String Client_Secret) async {
  print("GPS 데이터 가져오기 성공");
  SharedPreferences sp = await SharedPreferences.getInstance();
  Position position =
      await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  await sp.setString("Latitude", position.latitude.toString());
  await sp.setString("Longitude", position.longitude.toString());
  final String? lat = sp.getString("Latitude");
  final String? long = sp.getString("Longitude");

  // 네이버 지도에서 가지고 오기
  Map<String, String> headers_text = {
    "X-NCP-APIGW-API-KEY-ID": Client_ID,
    "X-NCP-APIGW-API-KEY": Client_Secret,
  };

  final Uri url = Uri.parse(dotenv.get('GPS_Domain') +
      "gc?coords=$long,$lat&orders=addr&output=json");
  final http.Response req = await http.get(url, headers: headers_text);

  // json 저장
  await sp.setString("locationjson", req.body);
  print(req.body);
  //처음에만 로그인을 저장하는 내부데이터를 구현한다.
  if (await sp.getString("loginInfo") == null) {
    await sp.setString("loginInfo", '{"login":0,"token":"","refreshtoken":""}');
    print("처음이라서 로그인 관련객체 생성됨");
  } else {
    String userdata = sp.getString("loginInfo")!;
    Map<String, dynamic> userinfo = jsonDecode(userdata);
    if (userinfo['login'] == 0) {
      await sp.setString("loginInfo",
          '{"login":0, "token":"","refreshtoken":"","userimage": "assets/default_avatar.jpg","username": "Guest","email": "Guest@Guest.com","term": "false","type": 2}');
    } else {}
  }
}

// 로딩 상태가 있는 페이지 로더
class PageLoader extends StatelessWidget {
  final Future<void> future;
  final WidgetBuilder builder;

  const PageLoader({required this.future, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return builder(context); // 로딩 완료 후 페이지 전환
        }
      },
    );
  }
}

// GoRouter 설정
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),

    // 로딩을 포함한 페이지 전환 예시
    GoRoute(
      path: '/map',
      builder: (context, state) => const mapPage(),
    ),
    GoRoute(
        path: '/community/review_create',
        builder: (context, state) => const review_create()),
    GoRoute(
        path: '/community/message_center',
        builder: (context, state) => const message_center()),
    GoRoute(
        path: '/community/reivew', builder: (context, state) => const reivew()),
    GoRoute(
        path: '/login', builder: (context, state) => const loguin()),
    GoRoute(
        path: '/signup', builder: (context, state) => const signup()),
    // 추가 경로를 여기에 정의
  ],
  errorBuilder: (context, state) => const ErrorPage(),
);

// 오류 페이지
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Page not found')),
    );
  }
}

class ALLlife extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ALL-Life',
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.black), // 아이콘 색상
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black), // 버튼 색상
        ),
      ),
      routerConfig: _router, // GoRouter 사용
    );
  }
}
