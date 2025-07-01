import 'package:flutter/material.dart';

class AppBarDSToken extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('SDK DSToken'),
      backgroundColor: Colors.teal[900],
    );
  }
}
