import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class reivew extends StatefulWidget {
  const reivew({super.key});

  @override
  _reivewState createState() => _reivewState();
}

class _reivewState extends State<reivew> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: SafeArea(
           child: Text("Test"),
         ),
    );
  }
}
