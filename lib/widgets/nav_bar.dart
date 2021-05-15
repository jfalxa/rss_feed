import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int _index;
  final Function(int) _onTap;

  NavBar({Key? key, required int index, required Function(int) onTap})
      : _index = index,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: _onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.rss_feed),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Sources',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmarks),
          label: 'Bookmarks',
        ),
      ],
    );
  }
}
