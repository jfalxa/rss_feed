import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/back_to_top.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/empty_indicator.dart';
import '../../widgets/article_refresh_lazy_list.dart';
import './feed_search.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PagingController<int, Article> _controller =
      PagingController(firstPageKey: 0);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
        controller: _controller,
        onRequest: repository.getArticles,
        onRefresh: repository.fetchAllSources,
        indicatorBuilder: (context) => EmptyIndicator(
          icon: Icons.rss_feed,
          title: 'No article found.',
          message: 'Try adding some sources or pulling to refresh the feed.',
        ),
      ),
    );
  }
}
