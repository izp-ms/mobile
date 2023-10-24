import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/pages/postcards_page/postcards_page_app_bar.dart';

class PostcardsPage extends StatelessWidget {
  const PostcardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const PostcardsPageAppBar(),
        drawer: CustomDrawer(context),
        body: const TabBarView(
          children: [
            Icon(Icons.bookmark_add_sharp),
            Icon(Icons.collections_bookmark),
          ],
        ),
      ),
    );
  }
}