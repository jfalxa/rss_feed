import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/article_list.dart';
import 'feed_search.dart';

class Feed extends StatelessWidget {
  final ScrollController controller;
  final PagingController<int, Article> pagingController =
      PagingController(firstPageKey: 0);

  Feed({Key key, this.controller}) : super(key: key);

  void goToArticleSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: FeedSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var repository = context.read<Repository>();

    return NestedScrollView(
      controller: controller,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        TopBar(
          title: 'Feed',
          onSearch: () => goToArticleSearch(context),
        ),
      ],
      body: RefreshArticleList(
        controller: pagingController,
        onRequest: repository.getArticles,
        onRefresh: repository.fetchAllSources,
      ),
    );
  }
}
