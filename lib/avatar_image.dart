import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/login_page.dart';

class AvatarImage extends ConsumerStatefulWidget {
  const AvatarImage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AvatarImageState();
}

class AvatarImageState extends ConsumerState<AvatarImage> {
  final _htmlContent = """ <img src='https://picsum.photos/200' /> """;
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.photoURL != null) {
      print(FirebaseAuth.instance.currentUser?.photoURL);
      // return Html(
      //   data:
      //       """ <img src=${FirebaseAuth.instance.currentUser?.photoURL} /> """,
      //   // Styling with CSS (not real CSS)
      //   style: {
      //     'img': Style(height: 24, width: 24),
      //   },
      // );
      return Image(
        height: 24,
        image: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
      );
    }
    return Container();
  }
}
