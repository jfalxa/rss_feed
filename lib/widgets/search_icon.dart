import 'package:flutter/material.dart';

class SearchIcon extends StatelessWidget {
  final Function _onSearch;

  SearchIcon({Key key, Function onSearch})
      : _onSearch = onSearch,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: _onSearch,
    );
  }
}
