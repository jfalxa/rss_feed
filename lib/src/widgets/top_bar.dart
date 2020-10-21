import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;

  TopBar({Key key, String title})
      : _title = title,
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(_title),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => null,
        ),
        actions: [
          PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: Text('Settings'),
                    ),
                  ])
        ]);
  }
}
