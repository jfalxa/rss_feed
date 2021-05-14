import 'package:flutter/material.dart';

import '../screens/settings/settings.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(child: Text('Settings'), value: 0),
      ],
      onSelected: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, SettingsControls.routeName);
        }
      },
    );
  }
}
