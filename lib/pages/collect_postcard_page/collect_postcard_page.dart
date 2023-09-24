import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/main_page_app_bar.dart';

class CollectPostcardPage extends StatefulWidget {
  const CollectPostcardPage({super.key});

  @override
  State<CollectPostcardPage> createState() => _CollectPostcardPageState();
}

class _CollectPostcardPageState extends State<CollectPostcardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: const Center(
        child: Text("Collect"),
      ),
    );
  }
}


