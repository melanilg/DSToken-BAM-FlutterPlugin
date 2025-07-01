import 'package:dstokenbam_example_new/src/pages/deleteTokenPage.dart';
import 'package:dstokenbam_example_new/src/pages/generateTokenPage.dart';
import 'package:dstokenbam_example_new/src/theme/theme.dart';
import 'package:dstokenbam_example_new/src/widgets/app_bar_dstoken.dart';
import 'package:flutter/material.dart';

import 'reSyncTokenPage.dart';
import 'syncTokenPage.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final buttonSyncToken = SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: _goSyncTokenPage,
        child: Text("SYNC"),
        style: ThemeSDK.actionButtonStyle(),
      ),
    );

    final buttonGenerateToken = SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: _goGenerateTokenPage,
        child: Text("GENERATE"),
        style: ThemeSDK.actionButtonStyle(),
      ),
    );

    final buttonReSyncToken = SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: _goReSyncTokenPage,
        child: Text("RESYNC"),
        style: ThemeSDK.actionButtonStyle(),
      ),
    );

    final buttonDeleteToken = SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: _goDeleteTokenPage,
        child: Text("DELETE"),
        style: ThemeSDK.actionButtonStyle(),
      ),
    );

    return Scaffold(
      appBar: AppBarDSToken(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buttonSyncToken,
              buttonReSyncToken,
              buttonGenerateToken,
              buttonDeleteToken,
            ],
          ),
        ),
      ),
    );
  }

  _goSyncTokenPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SyncTokenPage(),
      ),
    );
  }

  _goGenerateTokenPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateTokenPage(),
      ),
    );
  }

  _goReSyncTokenPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReSyncTokenPage(),
      ),
    );
  }

  _goDeleteTokenPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteTokenPage(),
      ),
    );
  }
}
