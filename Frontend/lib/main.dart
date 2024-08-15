import 'package:all_life/page/home.dart';
import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:flutter_native_splash/flutter_native_splash.dart';

//기본적으로 앱을 실행 하기 위한 코드 아래 수정 금지
void main() {
  runApp(ALLlife());
  FlutterNativeSplash.remove();
}

//페이지 라우트 역할을 해주는 코드입니다.
class ALLlife extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomePage());
          default:
            return MaterialPageRoute(builder: (context) => HomePage());
        }
      },
    );
  }
}
