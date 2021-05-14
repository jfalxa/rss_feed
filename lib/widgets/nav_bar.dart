import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int index;
  final Function onTap;

  NavBar({Key key, this.index, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
      backgroundColor: Colors.white,
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
