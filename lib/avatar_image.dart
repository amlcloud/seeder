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
      // return Image(
      //   height: 24,
      //   image: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
      // );
      return Tooltip(
          message: 'edit profile',
          child: Padding(
              padding: EdgeInsets.only(right: 4),
              child: Center(
                  child: CircleAvatar(
                      radius: 12,
                      
                      backgroundImage: FirebaseAuth
                                  .instance.currentUser?.photoURL ==
                              null
                          ? Image.asset("""../web/icons/Icon-192.png""").image
                          //: Image.asset("""../web/icons/Icon-192.png""").image
                          : Image.network(
                                  FirebaseAuth.instance.currentUser!.photoURL!)
                              .image))));
    }
    return Container();
  }
}
