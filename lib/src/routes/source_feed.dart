import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_feed/src/data/models.dart';

import '../data/repository.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';
import '../search/source_feed_search.dart';

class SourceFeed extends StatelessWidget {
  static final String routeName = '/source-feed';

  void _goToSourceFeedSearch(BuildContext context, Source source) async {
    await showSearch(
      context: context,
      delegate: SourceFeedSearch(source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    Source source = ModalRoute.of(context).settings.arguments;

    return Consumer<Repository>(
      builder: (context, repository, child) => Scaffold(
        appBar: PopTopBar(
          title: source.title,
          onSearch: () => _goToSourceFeedSearch(context, source),
        ),
        body: FutureArticleList(
          articles: repository.getSourceArticles(source),
          onRefresh: repository.refreshAllSources,
          onToggleBookmark: repository.toggleBookmark,
        ),
      ),
    );
  }
}
