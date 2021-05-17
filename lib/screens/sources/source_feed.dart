import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../models/article.dart';
import '../../services/repository.dart';
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

  void _goToSourceFeedSearch(BuildContext context, Source source) async {
    await showSearch(
      context: context,
      delegate: SourceFeedSearch(source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<Repository>();
    final source = ModalRoute.of(context)!.settings.arguments as Source;

    return BackToTop(
      builder: (context, controller) => NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          PopTopBar(
            title: source.title,
            onSearch: () => _goToSourceFeedSearch(context, source),
          )
        ],
        body: ArticleRefreshLazyList(
          controller: _controller,
          onRefresh: () => repository.fetchSource(source),
          onRequest: (l, o) => repository.getSourceArticles(source, l, o),
          indicatorBuilder: (context) => EmptyIndicator(
            icon: Icons.menu_book,
            title: 'No article found.',
            message: 'Try pulling to refresh the feed.',
          ),
        ),
      ),
    );
  }
}
