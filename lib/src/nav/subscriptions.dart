import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';

import '../data/store.dart';
import '../widgets/subscription_list_item.dart';

class Subscriptions extends StatelessWidget {
  final Store _store;
  final Function _onRefresh;

  Subscriptions({Key key, Store store, Function onRefresh})
      : _store = store,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var subscriptions = _store.getSubscriptions();

    return Scaffold(
      appBar: TopBar(title: "Subscriptions"),
      body: ListView.builder(
          itemCount: subscriptions.length,
          itemBuilder: (context, i) => SubscriptionListItem(
                subscription: subscriptions[i],
                store: _store,
                onRefresh: _onRefresh,
              )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => null,
      ),
    );
  }
}
