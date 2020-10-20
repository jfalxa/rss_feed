import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';
import '../widgets/article_list.dart';

class Bookmarks extends StatelessWidget {
  final Store _store;
  final Future _future;

  Bookmarks({Key key, Store store, Future future})
      : _future = future,
        _store = store,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("articles"),
        ),
        body: ArticleList(
          store: _store,
          future: _future,
        ));
  }
}
