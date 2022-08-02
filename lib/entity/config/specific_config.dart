import 'package:flutter/material.dart';

class SpecificConfig extends StatelessWidget {
  const SpecificConfig({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Column(children: [
          Expanded(
              child: Column(
            children: [
              Text('available specific templates'),
              // Expanded(
              //   child: SingleChildScrollView(
              //       child: ConfigList(entityId, "randomConfig")),
              // ),
              Divider(),
              Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Add templates'),
                  //addRandomConfigButton(context, ref),
                ],
              ))
            ],
          ))
        ]));
  }
}
