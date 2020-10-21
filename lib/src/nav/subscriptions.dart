import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';
import '../widgets/top_bar.dart';
import '../widgets/subscription_list_item.dart';
import '../routes/subscription_adder.dart';

class Subscriptions extends StatelessWidget {
  final Store _store;

  Subscriptions({Key key, Store store})
      : _store = store,
        super(key: key);

  void goToSubscriptionAdder(BuildContext context) {
    Navigator.pushNamed(context, SubscriptionAdder.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var subscriptions = _store.getSubscriptions();

    return Scaffold(
      appBar: TopBar(title: "Subscriptions"),
      body: ListView.builder(
          itemCount: subscriptions.length,
          itemBuilder: (context, i) =>
              SubscriptionListItem(subscription: subscriptions[i])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => goToSubscriptionAdder(context),
      ),
    );
  }
}
