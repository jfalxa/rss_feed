import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../data/models.dart';
import '../routes/subscription_feed.dart';
import '../widgets/loader.dart';
import '../widgets/top_bar.dart';
import '../widgets/subscription_list.dart';
import '../search/subscription_api_search.dart';

class Subscriptions extends StatelessWidget {
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
      var store = Provider.of<Store>(context, listen: false);
      store.addSubscription(subscription);
      store.refreshAllSubscriptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) => Scaffold(
        appBar: TopBar(title: 'Subscriptions'),
        body: Loader(
          future: store.loader,
          error: 'Error loading subscriptions',
          builder: (context, _) => FutureSubscriptionList(
            subscriptions: store.getSubscriptions(),
            onTap: (subscription) =>
                goToSubscriptionFeed(context, subscription),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => goToSubscriptionSearch(context),
        ),
      ),
    );
  }
}
