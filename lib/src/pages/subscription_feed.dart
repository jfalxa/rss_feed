import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed/src/data/models.dart';

import '../data/store.dart';
import '../widgets/article_list.dart';

class SubscriptionFeed extends StatelessWidget {
  final Store _store;
  final Subscription _subscription;
  final Function _onRefresh;

  SubscriptionFeed(
      {Key key, Store store, Subscription subscription, Function onRefresh})
      : _store = store,
        _subscription = subscription,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_subscription.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
        ),
        body: ArticleList(
          articles: _store.getSubscriptionArticles(_subscription),
          onRefresh: _onRefresh,
        ));
  }
}
