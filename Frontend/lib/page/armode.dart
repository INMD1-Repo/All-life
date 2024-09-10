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



  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AR GPS Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              platform.invokeMethod('startARGPS');
            },
            child: Text('Start AR GPS'),
          ),
        ),
      ),
    );
  }
}