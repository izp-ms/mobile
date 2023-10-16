import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/pages/postcards_page/postcards_page_app_bar.dart';
import 'package:mobile/pages/postcards_page/user_postcards_collection_page/user_postcards_collection.dart';

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
            UserPostcardsCollectionPage(),
            Icon(Icons.collections_bookmark),
          ],
        ),
      ),
    );
  }
}