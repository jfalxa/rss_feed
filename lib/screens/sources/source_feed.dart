import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../models/article.dart';
import '../../services/database.dart';
import '../../services/scraper.dart';
import '../../widgets/back_to_top.dart';
import '../../widgets/pop_top_bar.dart';
import '../../widgets/empty_indicator.dart';
import '../../widgets/article_refresh_lazy_list.dart';
import './source_feed_search.dart';

class SourceFeed extends StatefulWidget {
  static final String routeName = '/source-feed';

  @override
  _SourceFeedState createState() => _SourceFeedState();
}

class _SourceFeedState extends State<SourceFeed> {
  final PagingController<int, Article> _controller =
      PagingController(firstPageKey: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Source _getSource() {
    return ModalRoute.of(context)!.settings.arguments as Source;
  }

  Future<List<Article>> _getSourceArticles(int limit, int offset) {
    final source = _getSource();
    final database = context.read<Database>();
    return database.getSourceArticles(source, limit, offset);
  }

  Future _fetchSource() async {
    final source = _getSource();

    final database = context.read<Database>();
    final scraper = context.read<Scraper>();

    final feed = await scraper.fetch(source.url);
    if (feed != null) await database.refreshSource(source, feed.articles);
  }

  void _goToSourceFeedSearch() async {
    final source = _getSource();

    await showSearch(
      context: context,
      delegate: SourceFeedSearch(source: source),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyIndicator(
      icon: Icons.menu_book,
      title: 'No article found.',
      message: 'Try pulling to refresh the feed.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final source = _getSource();

    return BackToTop(
      builder: (context, controller) => NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          PopTopBar(title: source.title, onSearch: _goToSourceFeedSearch),
        ],
        body: ArticleRefreshLazyList(
          controller: _controller,
          onRefresh: _fetchSource,
          onRequest: _getSourceArticles,
          emptyBuilder: _buildEmpty,
        ),
      ),
    );
  }
}
