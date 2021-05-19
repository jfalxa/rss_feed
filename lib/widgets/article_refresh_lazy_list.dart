import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/article.dart';
import './article_lazy_list.dart';

class ArticleRefreshLazyList extends StatelessWidget {
  final PagingController<int, Article> _controller;
  final Future<List<Article>> Function(int, int) _onRequest;
  final Future Function() _onRefresh;
  final Widget Function(BuildContext) _emptyBuilder;

  ArticleRefreshLazyList({
    Key? key,
    required PagingController<int, Article> controller,
    required Future<List<Article>> Function(int, int) onRequest,
    required Future Function() onRefresh,
    required Widget Function(BuildContext) emptyBuilder,
  })   : _controller = controller,
        _onRequest = onRequest,
        _onRefresh = onRefresh,
        _emptyBuilder = emptyBuilder,
        super(key: key);

  Future refreshList() async {
    await _onRefresh();
    _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: ArticleLazyList(
        controller: _controller,
        onRequest: _onRequest,
        emptyBuilder: _emptyBuilder,
      ),
    );
  }
}
