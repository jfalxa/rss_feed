import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/store.dart';
import 'article_list_item.dart';

class ArticleList extends StatelessWidget {
  final Store _store;
  final Future _future;

  ArticleList({Key key, Store store, Future future})
      : _store = store,
        _future = future,
        super(key: key);

  Widget _buildArticleList() {
    return RefreshIndicator(
        onRefresh: () async {
          return _store.fetchAll();
        },
        child: ListView.builder(
            itemCount: _store.articles.length,
            itemBuilder: (context, i) =>
                ArticleListItem(i, article: _store.articles[i])));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildArticleList();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        });
  }
}
