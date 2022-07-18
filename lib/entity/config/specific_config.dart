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
          Row(
              mainAxisSize: MainAxisSize.max,
              children: [Expanded(child: Text('specific transactions'))])
        ]));
  }
}
