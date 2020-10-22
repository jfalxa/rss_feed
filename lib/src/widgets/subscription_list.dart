import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import 'loader.dart';
import 'subscription_list_item.dart';

class SubscriptionList extends StatelessWidget {
  final List<Subscription> _subscriptions;
  final Function _onTap;

  SubscriptionList({Key key, List<Subscription> subscriptions, Function onTap})
      : _subscriptions = subscriptions,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: _subscriptions.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, i) => SubscriptionListItem(
            subscription: _subscriptions[i], onTap: _onTap));
  }
}

class FutureSubscriptionList extends StatelessWidget {
  final Future<List<Subscription>> _subscriptions;
  final Function _onTap;

  FutureSubscriptionList(
      {Key key, Future<List<Subscription>> subscriptions, Function onTap})
      : _subscriptions = subscriptions,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<Subscription>>(
        future: _subscriptions,
        error: 'Error getting subscriptions from database',
        builder: (context, subscriptions) => ListView.separated(
            itemCount: subscriptions.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, i) => SubscriptionListItem(
                subscription: subscriptions[i], onTap: _onTap)));
  }
}
