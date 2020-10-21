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
      leading: IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.black87,
        ),
        onPressed: () => null,
      ),
      actions: [
        PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text('Settings'),
                  ),
                ])
      ],
      elevation: 1.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      textTheme: Theme.of(context).textTheme,
      actionsIconTheme: Theme.of(context).iconTheme,
    );
  }
}
