import 'package:flutter/material.dart';

import './search_icon.dart';
import './menu.dart';

class TopBar extends StatelessWidget {
  final String _title;
  final void Function()? _onSearch;

  TopBar({
    Key? key,
    required String title,
    void Function()? onSearch,
  })  : _title = title,
        _onSearch = onSearch,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(_title),
      leading: _onSearch != null ? SearchIcon(onSearch: _onSearch!) : null,
      actions: [Menu()],
      backwardsCompatibility: false,
    );
  }
}
