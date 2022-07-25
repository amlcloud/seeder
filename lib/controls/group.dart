import 'package:flutter/material.dart';

class Group extends StatelessWidget {
  final Widget child;

  const Group({required this.child});
  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.grey,
              )),
          child: Padding(padding: EdgeInsets.all(8), child: child)));
}
