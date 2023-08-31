import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/main_page_app_bar.dart';

class PostcardsPage extends StatefulWidget {
  const PostcardsPage({super.key});

  @override
  State<PostcardsPage> createState() => _PostcardsPageState();
}

class _PostcardsPageState extends State<PostcardsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: const Center(
        child: Text("Postcards"),
      ),
    );
  }
}


