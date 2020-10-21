import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';
import 'article_list_item.dart';

class ArticleList extends StatelessWidget {
  final Store _store;
  final Function _onRefresh;

  ArticleList({Key key, Store store, Function onRefresh})
      : _store = store,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var articles = _store.getArticles();

    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, i) =>
                ArticleListItem(i, article: articles[i])));
  }
}
