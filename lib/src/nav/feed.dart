import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repository.dart';
import '../widgets/loader.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';
import '../search/article_search.dart';

class Feed extends StatelessWidget {
  void _goToArticleSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: ArticleSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => Scaffold(
        appBar: TopBar(
          title: 'Feed',
          onSearch: () => _goToArticleSearch(context),
        ),
        body: Loader(
          future: repository.loader,
          error: 'Error refreshing articles',
          builder: (context, data) => FutureArticleList(
            articles: repository.getArticles(),
            onRefresh: repository.refreshAllSources,
            onToggleBookmark: repository.toggleBookmark,
          ),
        ),
      ),
    );
  }
}
