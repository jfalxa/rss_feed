import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/repository.dart';
import './screens/feed.dart';
import './screens/sources.dart';
import './screens/bookmarks.dart';
import './screens/source_feed.dart';

void main() {
  runApp(Provider(
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
  final ScrollController _feedController = ScrollController();
  final ScrollController _sourcesController = ScrollController();
  final ScrollController _bookmarksController = ScrollController();

  void navigate(int index) {
    ScrollController controller;

    if (index == 0) {
      controller = _feedController;
    } else if (index == 1) {
      controller = _sourcesController;
    } else if (index == 2) {
      controller = _bookmarksController;
    }

    controller?.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );

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
          Feed(controller: _feedController),
          Sources(controller: _sourcesController),
          Bookmarks(controller: _bookmarksController),
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
