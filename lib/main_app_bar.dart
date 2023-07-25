import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:seeder/router.dart';
import 'package:widgets/custom_app_bar.dart';

class MainAppBar {
  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref,
      {bool autoImplyLeading = true}) {
    return CustomAppBar(
      // automaticallyImplyLeading: autoImplyLeading,
      tabs: [
        'Configs',
        'Entities',
        'Batches',
        'Feeds',
      ],
      maxTabWidth: 50,
      onTabSelected: (BuildContext context, tabIndex, tab) =>
          ref.read(routerProvider).go('/${tab.toLowerCase()}')
      // context.go('/${tab.toLowerCase()}')
      // Navigator.of(context).pushNamed('/${tab.toLowerCase()}')
      ,
      // automaticallyImplyLeading:
      //     (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
      //         ? true
      //         : false,
      // leadingWidth:
      //     (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH) ? null : 100,
      leading: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? null
          : Padding(
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/Logo_Dark.svg',
              )),
      // title: Text("Sanctions Screener", style: TextStyle(fontSize: 20)),
      // tabsAlignment: TabsAlignment.left,
      // onTabSelected: (context, tabIndex, tab) {
      //   Navigator.of(context).pushNamed('/${tab.toLowerCase()}');
      // }
    );
  }
}
