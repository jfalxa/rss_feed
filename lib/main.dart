import 'package:flutter/material.dart';

import 'src/data/api.dart';
import 'src/data/store.dart';

import 'src/app.dart';
import 'src/routes/article_web_view.dart';
import 'src/routes/subscription_feed.dart';

const DEMO_FEEDS = [
  "https://www.lemonde.fr/rss/une.xml",
  "https://rss.nytimes.com/services/xml/rss/nyt/Business.xml"
];

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

    _store = Store([], []);

    initDemo();
  }

  void initDemo() async {
    var subscriptions =
        await Future.wait(DEMO_FEEDS.map((url) => Api.getSubscription(url)));

    subscriptions.forEach((subscription) {
      _store.addSubscription(subscription);
    });

    refresh();
  }

  Future refresh() async {
    await _store.refreshSubscriptions();

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
          SubscriptionFeed.routeName: (context) => SubscriptionFeed(
                store: _store,
                onRefresh: refresh,
              ),
        });
  }
}
