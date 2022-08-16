import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/login_page.dart';

class AvatarImage extends ConsumerWidget {
  const AvatarImage({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context, WidgetRef ref) {
      return Tooltip(
          message: 'edit profile',
          child: Padding(
              padding: EdgeInsets.only(right: 4),
              child: Center(
                  child: CircleAvatar(
                      radius: 14,
                      backgroundImage: FirebaseAuth
                                  .instance.currentUser?.photoURL ==
                              null
                          ? Image.asset("""../web/icons/Icon-192.png""").image
                          : Image.network(
                                  FirebaseAuth.instance.currentUser!.photoURL!)
                              .image))),
                              );
  }
}
