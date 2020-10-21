import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import 'article_list_item.dart';

class ArticleList extends StatelessWidget {
  final List<Article> _articles;
  final Function _onRefresh;

  ArticleList({Key key, List<Article> articles, Function onRefresh})
      : _articles = articles,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: _articles.length,
            itemBuilder: (context, i) =>
                ArticleListItem(article: _articles[i])));
  }
}
