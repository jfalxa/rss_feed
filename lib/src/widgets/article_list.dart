import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import 'loader.dart';
import 'article_list_item.dart';

class ArticleList extends StatelessWidget {
  final List<Article> _articles;
  final Future _loader;
  final Function _onRefresh;

  ArticleList(
      {Key key, List<Article> articles, Future loader, Function onRefresh})
      : _articles = articles,
        _loader = loader,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader(
        future: _loader,
        error: 'Error loading articles',
        builder: (context, data) => RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
                itemCount: _articles.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, i) =>
                    ArticleListItem(article: _articles[i]))));
  }
}
