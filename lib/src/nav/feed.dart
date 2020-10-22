import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';
import '../widgets/article_list.dart';
import '../widgets/top_bar.dart';

class Feed extends StatelessWidget {
  final Store _store;
  final Function _onRefresh;

  Feed({Key key, Store store, Function onRefresh})
      : _store = store,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: "Feed"),
        body: ArticleList(
          loader: _store.loader,
          articles: _store.getArticles(),
          onRefresh: _onRefresh,
        ));
  }
}
