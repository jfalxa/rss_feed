import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';

import '../data/store.dart';
import '../widgets/top_bar.dart';
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
        appBar: TopBar(title: "Bookmarks"),
        body: ArticleList(
          store: _store,
          future: _future,
        ));
  }
}
