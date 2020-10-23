import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import 'loader.dart';
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
        child: _articles.length == 0
            ? Center(child: Text("No article available."))
            : ListView.separated(
                itemCount: _articles.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, i) =>
                    ArticleListItem(article: _articles[i]),
              ));
  }
}

class FutureArticleList extends StatelessWidget {
  final Future<List<Article>> _articles;
  final Function _onRefresh;

  FutureArticleList(
      {Key key, Future<List<Article>> articles, Function onRefresh})
      : _articles = articles,
        _onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<Article>>(
      future: _articles,
      error: 'Error loading articles from database',
      builder: (context, articles) =>
          ArticleList(articles: articles, onRefresh: _onRefresh),
    );
  }
}
