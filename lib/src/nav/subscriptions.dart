import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';

import '../data/store.dart';
import '../widgets/subscription_list_item.dart';

class Subscriptions extends StatelessWidget {
  final Store _store;
  final Future _future;

  Subscriptions({Key key, Store store, Future future})
      : _future = future,
        _store = store,
        super(key: key);

  Widget _buildSubscriptionList() {
    var subscriptions = _store.subscriptions.values.toList();
    return ListView.builder(
        itemCount: subscriptions.length,
        itemBuilder: (context, i) =>
            SubscriptionListItem(i, subscription: subscriptions[i]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Subscriptions"),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildSubscriptionList();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => print('add subscription'),
      ),
    );
  }
}
