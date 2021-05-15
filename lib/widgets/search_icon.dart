import 'package:flutter/material.dart';

class SearchIcon extends StatelessWidget {
  final void Function() _onSearch;

  SearchIcon({Key? key, required void Function() onSearch})
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
