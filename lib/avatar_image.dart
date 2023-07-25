import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/custom_login_page.dart';

class AvatarImage extends ConsumerWidget {
  const AvatarImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
        message: 'edit profile',
        child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: Center(
                child: FirebaseAuth.instance.currentUser?.photoURL == null
                    ? Icon(Icons.person)
                    : CircleAvatar(
                        radius: 14,
                        backgroundImage: Image.network(
                                FirebaseAuth.instance.currentUser!.photoURL!)
                            .image))));
  }
//                   child: CircleAvatar(
//           radius: 14,
//           backgroundImage: FirebaseAuth
//                       .instance.currentUser?.photoURL ==
//                   null
//               ? Icon(Icons.person)
//               : Image.network(
//                       FirebaseAuth.instance.currentUser!.photoURL!)
//                   .image))),
//                   );
//   }
}
