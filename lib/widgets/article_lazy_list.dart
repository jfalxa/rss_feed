import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/article.dart';
import './lazy_scroll_view.dart';
import './article_list_item.dart';

class ArticleLazyList extends StatelessWidget {
  static final int limit = 20;
  final PagingController<int, Article> controller;
  final Future<List<Article>> Function(int, int) onRequest;

  ArticleLazyList({Key key, this.controller, this.onRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LazyScrollView<Article>(
      controller: controller,
      onRequest: onRequest,
      itemBuilder: (context, article, i) => ArticleListItem(article: article),
    );
  }
}
