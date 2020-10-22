import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import 'subscription_list_item.dart';

class SubscriptionList extends StatelessWidget {
  final List<Subscription> _subscriptions;
  final Function _onTap;

  SubscriptionList(
      {Key key,
      List<Subscription> subscriptions,
      Future loader,
      Function onTap})
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
