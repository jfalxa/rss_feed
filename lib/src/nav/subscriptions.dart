import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';
import '../data/models.dart';
import '../routes/subscription_feed.dart';
import '../widgets/top_bar.dart';
import '../widgets/subscription_list.dart';
import '../search/subscription_api_search.dart';

class Subscriptions extends StatelessWidget {
  final Store _store;
  final Function _onRefresh;

  Subscriptions({Key key, Store store, Function onRefresh})
      : _store = store,
        _onRefresh = onRefresh,
        super(key: key);

  void goToSubscriptionFeed(BuildContext context, Subscription subscription) {
    Navigator.pushNamed(context, SubscriptionFeed.routeName,
        arguments: subscription);
  }

  void goToSubscriptionSearch(BuildContext context) async {
    final Subscription subscription = await showSearch<Subscription>(
      context: context,
      delegate: SubscriptionApiSearch(),
    );

    if (subscription != null) {
      _store.addSubscription(subscription);
      _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Subscriptions"),
      body: SubscriptionList(
        subscriptions: _store.getSubscriptions(),
        onTap: (subscription) => goToSubscriptionFeed(context, subscription),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => goToSubscriptionSearch(context),
      ),
    );
  }
}
