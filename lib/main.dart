import 'package:flutter/material.dart';

import 'src/data/store.dart';
import 'src/data/models.dart';

import 'src/app.dart';
import 'src/routes/article_web_view.dart';
import 'src/routes/subscription_adder.dart';
import 'src/routes/subscription_feed.dart';

const Map<String, Subscription> DEMO = {
  "https://www.lemonde.fr/rss/une.xml": null,
  "https://rss.nytimes.com/services/xml/rss/nyt/Business.xml": null
};

void main() {
  runApp(RssFeed());
}

class RssFeed extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<RssFeed> {
  Store _store;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();

    _store = Store(DEMO, []);
    refresh();
  }

  Future refresh() async {
    await _store.refresh();
    setState(() {
      _store = _store;
    });
  }

  void navigate(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rss Feed',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => App(
              store: _store,
              navIndex: _navIndex,
              onNavigate: navigate,
              onRefresh: refresh),
          ArticleWebView.routeName: (context) => ArticleWebView(),
          SubscriptionAdder.routeName: (context) => SubscriptionAdder(
                store: _store,
                onRefresh: refresh,
              ),
          SubscriptionFeed.routeName: (context) => SubscriptionFeed(
                store: _store,
                onRefresh: refresh,
              ),
        });
  }
}
