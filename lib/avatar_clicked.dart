import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/login_page.dart';
//import 'package:seeder/avatar_image.dart'

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Edit my Profile'), 
          content: const Text('test@amlcloud.io'), //Add image
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Sign out'),
              child: const Text('Sign out'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Close'),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}

