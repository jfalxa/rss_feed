import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed/src/data/models.dart';

import '../data/store.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';

class SubscriptionFeed extends StatelessWidget {
  static final String routeName = '/subscription-feed';

  final Store _store;
  final Function _onRefresh;

  SubscriptionFeed({Key key, Store store, Function onRefresh})
      : _store = store,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Subscription subscription = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: PopTopBar(title: subscription.title),
        body: ArticleList(
          loader: _store.loader,
          articles: _store.getSubscriptionArticles(subscription),
          onRefresh: _onRefresh,
        ));
  }
}
