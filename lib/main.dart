import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/data/repository.dart';
import 'src/app.dart';
import 'src/routes/article_web_view.dart';
import 'src/routes/subscription_feed.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Repository(),
    child: RssFeed(),
  ));
}

class RssFeed extends StatelessWidget {
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
        '/': (context) => App(),
        ArticleWebView.routeName: (context) => ArticleWebView(),
        SubscriptionFeed.routeName: (context) => SubscriptionFeed()
      },
    );
  }
}
