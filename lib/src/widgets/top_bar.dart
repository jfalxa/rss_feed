import 'package:flutter/material.dart';

class SearchIcon extends StatelessWidget {
  final Function _onSearch;

  SearchIcon({Key key, Function onSearch})
      : _onSearch = onSearch,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.search,
        color: Colors.black87,
      ),
      onPressed: _onSearch,
    );
  }
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  final Function _onSearch;

  TopBar({Key key, String title, Function onSearch})
      : _title = title,
        _onSearch = onSearch,
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      elevation: 1.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      textTheme: Theme.of(context).textTheme,
      actionsIconTheme: Theme.of(context).iconTheme,
    );
  }
}

class SliverTopBar extends StatelessWidget {
  final String _title;
  final Function _onSearch;

  SliverTopBar({Key key, String title, Function onSearch})
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

class PopTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  final Function _onSearch;

  PopTopBar({Key key, String title, Function onSearch})
      : _title = title,
        _onSearch = onSearch,
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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

class SliverPopTopBar extends StatelessWidget {
  final String _title;
  final Function _onSearch;

  SliverPopTopBar({Key key, String title, Function onSearch})
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
