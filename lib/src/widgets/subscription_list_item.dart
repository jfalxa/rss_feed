import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../data/models.dart';

class SubscriptionListItem extends StatelessWidget {
  final Subscription _subscription;
  final Function _onTap;

  SubscriptionListItem({Key key, Subscription subscription, Function onTap})
      : _subscription = subscription,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _onTap(_subscription),
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
                    Text(_subscription.title ?? 'Title',
                        style: Theme.of(context).textTheme.headline6),
                    Container(
                        margin: EdgeInsets.only(top: 4.0, bottom: 16.0),
                        child: Text(_subscription.url,
                            style: Theme.of(context).textTheme.caption)),
                  ],
                ))
              ],
            )));
  }
}
