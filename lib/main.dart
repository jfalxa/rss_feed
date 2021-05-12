import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/repository.dart';
import './screens/feed.dart';
import './screens/sources.dart';
import './screens/bookmarks.dart';
import './screens/source_feed.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Repository(),
    child: Main(),
  ));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS Feed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => App(),
        SourceFeed.routeName: (context) => SourceFeed()
      },
    );
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  int _navIndex = 0;
  final ScrollController _feedScroll = ScrollController();
  final ScrollController _sourcesScroll = ScrollController();
  final ScrollController _bookmarksScroll = ScrollController();

  void navigate(int index) {
    if (index == 0) {
      _feedScroll.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }

    if (index == 1) {
      _sourcesScroll.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }

    if (index == 2) {
      _bookmarksScroll.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }

    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: [
          Feed(controller: _feedScroll),
          Sources(controller: _sourcesScroll),
          Bookmarks(controller: _bookmarksScroll),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: navigate,
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
      ),
    );
  }
}
