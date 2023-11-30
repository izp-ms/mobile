import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/pages/friends_page/all_friends_page.dart';
import 'package:mobile/pages/friends_page/followed_by_page.dart';
import 'package:mobile/pages/friends_page/following_page.dart';
import 'package:mobile/pages/friends_page/friends_page_app_bar.dart';


class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const FriendsPageAppBar(),
        drawer: CustomDrawer(context),
        body: const TabBarView(
          children: [
            FollowingPage(),
            FollowedByPage(),
            AllFriendsPage(),
          ],
        ),
      ),
    );
  }
}