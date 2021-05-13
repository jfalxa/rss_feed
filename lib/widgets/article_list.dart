import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../services/repository.dart';
import './article_list_item.dart';
import './infinite_scroll.dart';

class ArticleList extends StatelessWidget {
  final List<Article> _articles;
  final Function(Article) _onToggleBookmark;

  ArticleList({
    Key key,
    List<Article> articles,
    Function(Article) onToggleBookmark,
  })  : _articles = articles,
        _onToggleBookmark = onToggleBookmark,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_articles.length == 0) {
      return Center(child: Text('No articles found.'));
    }

    return ListView.separated(
      itemCount: _articles.length,
      padding: EdgeInsets.all(0),
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, i) => ArticleListItem(
        article: _articles[i],
        onToggleBookmark: _onToggleBookmark,
      ),
    );
  }
}

class InfiniteArticleList extends StatelessWidget {
  final Future<List<Article>> Function(int, int) fetch;
  final Function(Article) onToggleBookmark;
  final ScrollController controller;

  InfiniteArticleList(
      {Key key, this.fetch, this.controller, this.onToggleBookmark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => InfiniteScroll(
        fetch: fetch,
        itemBuilder: (context, article) => ArticleListItem(
          article: article,
          onToggleBookmark: onToggleBookmark,
        ),
      ),
    );
  }
}

class RefreshArticleList extends StatelessWidget {
  final Future<List<Article>> Function(int, int) fetch;
  final Function onRefresh;
  final Function(Article) onToggleBookmark;

  RefreshArticleList({
    Key key,
    this.fetch,
    this.onRefresh,
    this.onToggleBookmark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: InfiniteArticleList(
        fetch: fetch,
        onToggleBookmark: onToggleBookmark,
      ),
    );
  }
}
