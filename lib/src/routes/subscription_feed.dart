import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_feed/src/data/models.dart';

import '../data/store.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';

class SubscriptionFeed extends StatelessWidget {
  static final String routeName = '/subscription-feed';

  @override
  Widget build(BuildContext context) {
    Subscription subscription = ModalRoute.of(context).settings.arguments;

    return Consumer<Store>(
      builder: (context, store, child) => Scaffold(
        appBar: PopTopBar(title: subscription.title),
        body: FutureArticleList(
          articles: store.getSubscriptionArticles(subscription),
          onRefresh: store.refreshAllSubscriptions,
        ),
      ),
    );
  }
}
