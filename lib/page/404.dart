import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {

  NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('你进入了未知之地，你在赣神魔？？'), 
      ),
    );
  }
}