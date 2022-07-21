import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Group extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.grey,
              )),
          child: Text('hello')));
}
