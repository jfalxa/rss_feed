import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../services/repository.dart';
import './article_list_item.dart';
import './infinite_scroll.dart';
import './separator.dart';

class ArticleList extends StatelessWidget {
  final List<Article> articles;

  ArticleList({Key key, this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (articles.length == 0) {
      return Center(child: Text('No articles found.'));
    }

    return ListView.separated(
      itemCount: articles.length,
      padding: EdgeInsets.all(0),
      separatorBuilder: separatorBuilder,
      itemBuilder: (context, i) => ArticleListItem(
        article: articles[i],
      ),
    );
  }
}

class InfiniteArticleList extends StatelessWidget {
  final Future<List<Article>> Function(int, int) fetch;

  InfiniteArticleList({Key key, this.fetch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => InfiniteScroll(
        fetch: fetch,
        itemBuilder: (context, article) => ArticleListItem(
          article: article,
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
      ),
    );
  }
}
