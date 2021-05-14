import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/article.dart';
import './article_lazy_list.dart';

class ArticleRefreshLazyList extends StatelessWidget {
  final PagingController<int, Article> controller;
  final Future<List<Article>> Function(int, int) onRequest;
  final Future Function() onRefresh;

  ArticleRefreshLazyList({
    Key key,
    this.controller,
    this.onRequest,
    this.onRefresh,
  }) : super(key: key);

  Future refreshList() async {
    try {
      await onRefresh();
      controller.refresh();
    } catch (err) {
      print("Error refreshing articles: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: ArticleLazyList(
        controller: controller,
        onRequest: onRequest,
      ),
    );
  }
}
