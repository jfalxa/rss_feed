import 'package:flutter/material.dart';

import './search_icon.dart';
import './menu.dart';

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
      leading: _onSearch == null ? null : SearchIcon(onSearch: _onSearch),
      actions: [Menu()],
      backwardsCompatibility: false,
    );
  }
}
