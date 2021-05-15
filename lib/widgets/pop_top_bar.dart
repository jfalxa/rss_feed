import 'package:flutter/material.dart';

import './search_icon.dart';

class PopTopBar extends StatelessWidget {
  final String _title;
  final void Function()? _onSearch;

  PopTopBar({Key? key, required String title, void Function()? onSearch})
      : _title = title,
        _onSearch = onSearch,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(_title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: _onSearch != null ? [SearchIcon(onSearch: _onSearch!)] : null,
      backwardsCompatibility: false,
    );
  }
}
