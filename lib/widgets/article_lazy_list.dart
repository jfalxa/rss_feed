import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/article.dart';
import './lazy_scroll_view.dart';
import './article_list_item.dart';

class ArticleLazyList extends StatelessWidget {
  final PagingController<int, Article> _controller;
  final Future<List<Article>> Function(int, int) _onRequest;
  final Widget Function(BuildContext) _emptyBuilder;

  ArticleLazyList({
    Key? key,
    required PagingController<int, Article> controller,
    required Future<List<Article>> Function(int, int) onRequest,
    required Widget Function(BuildContext) emptyBuilder,
  })   : _controller = controller,
        _onRequest = onRequest,
        _emptyBuilder = emptyBuilder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LazyScrollView<Article>(
      controller: _controller,
      onRequest: _onRequest,
      itemBuilder: (context, article, i) => ArticleListItem(article: article),
      emptyBuilder: _emptyBuilder,
    );
  }
}
