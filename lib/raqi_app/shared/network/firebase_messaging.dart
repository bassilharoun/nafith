import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Firebase_Messaging extends StatefulWidget {

  @override
  State<Firebase_Messaging> createState() => _Firebase_MessagingState();
}

class _Firebase_MessagingState extends State<Firebase_Messaging> {


  @override
  void initState() {
    configureCallbacks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }

  void configureCallbacks() {
    print("configure calling");


  }



}


