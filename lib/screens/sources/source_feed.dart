import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/back_to_top.dart';
import '../../widgets/pop_top_bar.dart';
import '../../widgets/article_refresh_lazy_list.dart';
import './source_feed_search.dart';

class SourceFeed extends StatelessWidget {
  static final String routeName = '/source-feed';

  final PagingController<int, Article> _controller =
      PagingController(firstPageKey: 0);

  void _goToSourceFeedSearch(BuildContext context, Source source) async {
    await showSearch(
      context: context,
      delegate: SourceFeedSearch(source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    var repository = context.read<Repository>();
    Source source = ModalRoute.of(context).settings.arguments;

    return BackToTop(
      header: PopTopBar(
        title: source.title,
        onSearch: () => _goToSourceFeedSearch(context, source),
      ),
      body: ArticleRefreshLazyList(
        controller: _controller,
        onRefresh: () => repository.fetchSource(source),
        onRequest: (l, o) => repository.getSourceArticles(source, l, o),
      ),
    );
  }
}
