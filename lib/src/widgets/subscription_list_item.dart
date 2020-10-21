import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../data/models.dart';

class SubscriptionListItem extends StatelessWidget {
  final Subscription _subscription;
  final int _index;

  SubscriptionListItem(int index, {Key key, Subscription subscription})
      : _subscription = subscription,
        _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var top = _index == 0 ? 20.0 : 8.0;

    return Container(
        padding: EdgeInsets.only(right: 16.0, left: 16.0, top: top),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: CircleAvatar(), margin: EdgeInsets.only(right: 16.0)),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_subscription.title,
                    style: Theme.of(context).textTheme.headline6),
                Container(
                    margin: EdgeInsets.only(top: 4.0, bottom: 8.0),
                    child: Text(_subscription.link,
                        style: Theme.of(context).textTheme.caption)),
                Divider()
              ],
            ))
          ],
        ));
  }
}
