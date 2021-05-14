import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/article.dart';
import './article_list_item.dart';
import './lazy_scroll_view.dart';

class LazyArticleList extends StatelessWidget {
  static final int limit = 20;
  final PagingController<int, Article> controller;
  final Future<List<Article>> Function(int, int) onRequest;

  LazyArticleList({Key key, this.controller, this.onRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LazyScrollView<Article>(
      controller: controller,
      onRequest: onRequest,
      itemBuilder: (context, article, i) => ArticleListItem(article: article),
    );
  }
}

class RefreshArticleList extends StatelessWidget {
  final PagingController<int, Article> controller;
  final Future<List<Article>> Function(int, int) onRequest;
  final Future Function() onRefresh;

  RefreshArticleList({
    Key key,
    this.controller,
    this.onRequest,
    this.onRefresh,
  }) : super(key: key);

  Future refreshList() async {
    await onRefresh();
    controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: LazyArticleList(
        controller: controller,
        onRequest: onRequest,
      ),
    );
  }
}
