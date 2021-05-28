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
    _controller.dispose();
    super.dispose();
  }

  void _goToFeedSearch() async {
    await showSearch(
      context: context,
      delegate: FeedSearch(),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyIndicator(
      icon: Icons.rss_feed,
      title: 'No article found.',
      message: 'Try adding some sources or pulling to refresh the feed.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<Repository>();
    _controller.refresh();

    return BackToTop(
      heroTag: "feed",
      builder: (context, controller) => NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          TopBar(
            title: 'Feed',
            onSearch: _goToFeedSearch,
          ),
        ],
        body: ArticleRefreshLazyList(
          controller: _controller,
          onRequest: repository.getArticles,
          onRefresh: repository.fetchAllSources,
          emptyBuilder: _buildEmpty,
        ),
      ),
    );
  }
}
