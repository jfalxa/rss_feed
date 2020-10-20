import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';
import '../widgets/article_list.dart';

class Feed extends StatelessWidget {
  final Store _store;
  final Future _future;

  Feed({Key key, Store store, Future future})
      : _store = store,
        _future = future,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Feed"),
        ),
        body: ArticleList(
          store: _store,
          future: _future,
        ));
  }
}
