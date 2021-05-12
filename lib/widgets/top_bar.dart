import 'package:flutter/material.dart';

import 'search_icon.dart';

class TopBar extends StatelessWidget {
  final String _title;
  final Function _onSearch;

  TopBar({Key key, String title, Function onSearch})
      : _title = title,
        _onSearch = onSearch,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(_title),
      leading: SearchIcon(onSearch: _onSearch),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: Text('Settings'),
            ),
          ],
        )
      ],
      centerTitle: true,
      backgroundColor: Colors.white,
      textTheme: Theme.of(context).textTheme,
      actionsIconTheme: Theme.of(context).iconTheme,
    );
  }
}

class PopTopBar extends StatelessWidget {
  final String _title;
  final Function _onSearch;

  PopTopBar({Key key, String title, Function onSearch})
      : _title = title,
        _onSearch = onSearch,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(_title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black87,
        onPressed: () => Navigator.pop(context),
      ),
      actions: _onSearch == null ? [] : [SearchIcon(onSearch: _onSearch)],
      centerTitle: true,
      backgroundColor: Colors.white,
      textTheme: Theme.of(context).textTheme,
    );
  }
}
