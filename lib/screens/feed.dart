import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/repository.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';
import './feed_search.dart';

class Feed extends StatelessWidget {
  final ScrollController controller;

  Feed({Key key, this.controller}) : super(key: key);

  void _goToArticleSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: FeedSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          TopBar(
            title: 'Feed',
            onSearch: () => _goToArticleSearch(context),
          ),
        ],
        body: RefreshArticleList(
          fetch: (limit, offset) => repository.getArticles(limit, offset),
          onRefresh: repository.fetchAllSources,
          onToggleBookmark: repository.toggleBookmark,
        ),
      ),
    );
  }
}
