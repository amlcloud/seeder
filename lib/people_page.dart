import 'package:flutter/material.dart';
import 'package:seeder/app_bar.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.getBar(context),
      body: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text('Test Widget 1'),
              ),
              ListTile(
                title: Text('Text Widget 1'),
              )
            ],
          )),
    );
  }
}
