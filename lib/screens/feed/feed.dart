import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/back_to_top.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/article_refresh_lazy_list.dart';
import './feed_search.dart';

class Feed extends StatelessWidget {
  final PagingController<int, Article> _pagingController =
      PagingController(firstPageKey: 0);

  void _goToArticleSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: FeedSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var repository = context.read<Repository>();

    return BackToTop(
      header: TopBar(
        title: 'Feed',
        onSearch: () => _goToArticleSearch(context),
      ),
      body: ArticleRefreshLazyList(
        controller: _pagingController,
        onRequest: repository.getArticles,
        onRefresh: repository.fetchAllSources,
      ),
    );
  }
}
