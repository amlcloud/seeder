import 'package:flutter/material.dart';
import 'package:seeder/app_bar.dart';

class SetsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.getBar(context),
      body: Container(
        alignment: Alignment.center,
        child: Text('Page 2'),
      ),
    );
  }
}
