import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rss_feed/src/routes/subscription_feed.dart';

import '../data/models.dart';
import '../routes/subscription_feed.dart';

class SubscriptionListItem extends StatelessWidget {
  final Subscription _subscription;

  SubscriptionListItem({Key key, Subscription subscription})
      : _subscription = subscription,
        super(key: key);

  void goToSubscription(BuildContext context) {
    Navigator.pushNamed(context, SubscriptionFeed.routeName,
        arguments: _subscription);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => goToSubscription(context),
        child: Container(
            padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: CircleAvatar(),
                    margin: EdgeInsets.only(right: 16.0)),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_subscription.title,
                        style: Theme.of(context).textTheme.headline6),
                    Container(
                        margin: EdgeInsets.only(top: 4.0, bottom: 16.0),
                        child: Text(_subscription.link,
                            style: Theme.of(context).textTheme.caption)),
                    Divider(height: 1)
                  ],
                ))
              ],
            )));
  }
}
