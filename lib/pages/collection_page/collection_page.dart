import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/pages/collection_page/collection_page_app_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/all_postcards_collection.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/user_postcards_collection.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){final FocusScopeNode currentScope = FocusScope.of(context);
      if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
      }},
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const CollectionPageAppBar(),
          drawer: CustomDrawer(context),
          body: const TabBarView(
            children: [
              UserPostcardsCollectionPage(),
              AllPostcardsCollectionPage(),
            ],
          ),
        ),
      ),
    );
  }
}