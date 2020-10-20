import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';

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
        itemBuilder: (context, i) => Text(subscriptions[i].title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Subscriptions"),
        ),
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildSubscriptionList();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            }));
  }
}
