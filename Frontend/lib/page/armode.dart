import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'map.dart';

class armodePage extends StatefulWidget {
  const armodePage({super.key});

  @override
  _ArmodePageState createState() => _ArmodePageState();
}
class _ArmodePageState extends State<armodePage> with WidgetsBindingObserver {
  static const platform = MethodChannel('com.deu.hackton.all_life/native');

  Future<void> _startFragmentActivity() async {
    try {
      await platform.invokeMethod('startFragmentActivity');
    } on PlatformException catch (e) {
      print("Fragment Activity를 시작하는 중 오류 발생: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter와 Fragment'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _startFragmentActivity,
            child: Text('Fragment Activity 시작'),
          ),
        ),
      ),
    );
  }
}