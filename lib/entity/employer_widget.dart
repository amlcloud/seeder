import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class EmployerDetails extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) => 
    Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.grey,
              )),
      child: Column(
        children: [
          Text('Employer Detial'),
          ListTile(title: Text('Company Name: '),
          trailing: Text('Comapny Name Example')),
          ListTile(title: Text('Company Account: '),
          trailing: Text('Account Example')),
          ListTile(title: Text('Company Bank BSB: '),
          trailing: Text('BSB Example')),
          ListTile(title: Text('Company Bank: '),
          trailing: Text('Bank Example')),
        ]),);
}