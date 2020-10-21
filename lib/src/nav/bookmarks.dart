import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';

import '../data/store.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';

class Bookmarks extends StatelessWidget {
  final Store _store;
  final Function _onRefresh;

  Bookmarks({Key key, Store store, Function onRefresh})
      : _store = store,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: "Bookmarks"),
        body: ArticleList(
          store: _store,
          onRefresh: _onRefresh,
        ));
  }
}
