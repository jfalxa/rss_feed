import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import 'loader.dart';
import 'article_list_item.dart';

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

class RefreshArticleList extends StatelessWidget {
  final List<Article> _articles;
  final Function _onRefresh;
  final Function(Article) _onToggleBookmark;

  RefreshArticleList({
    Key key,
    List<Article> articles,
    Function onRefresh,
    Function(Article) onToggleBookmark,
  })  : _articles = articles,
        _onRefresh = onRefresh,
        _onToggleBookmark = onToggleBookmark,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_articles.length == 0) {
      return Center(child: Text('No articles found.'));
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ArticleList(
        articles: _articles,
        onToggleBookmark: _onToggleBookmark,
      ),
    );
  }
}

class FutureArticleList extends StatelessWidget {
  final Future<List<Article>> _articles;
  final Function _onRefresh;
  final Function _onToggleBookmark;

  FutureArticleList({
    Key key,
    Future<List<Article>> articles,
    Function onRefresh,
    Function(Article) onToggleBookmark,
  })  : _articles = articles,
        _onRefresh = onRefresh,
        _onToggleBookmark = onToggleBookmark,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<Article>>(
      future: _articles,
      error: 'Error loading articles from database',
      builder: (context, articles) => RefreshArticleList(
        articles: articles,
        onRefresh: _onRefresh,
        onToggleBookmark: _onToggleBookmark,
      ),
    );
  }
}
