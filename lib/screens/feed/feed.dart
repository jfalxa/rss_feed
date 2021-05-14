import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/back_to_top.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/article_refresh_lazy_list.dart';
import './feed_search.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

// class Feed extends StatelessWidget {
class _FeedState extends State<Feed> {
  bool showBackToTop = false;

  final ScrollController scrollController = ScrollController();
  final PagingController<int, Article> pagingController =
      PagingController(firstPageKey: 0);

  @override
  initState() {
    super.initState();

    scrollController.addListener(() {
      var position = scrollController.position.pixels;
      var max = scrollController.position.maxScrollExtent;

      if (!showBackToTop && position >= max) {
        setState(() {
          showBackToTop = true;
        });
      } else if (showBackToTop && position < max) {
        setState(() {
          showBackToTop = false;
        });
      }
    });
  }

  void backToTop() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  void goToArticleSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: FeedSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var repository = context.read<Repository>();

    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          TopBar(
            title: 'Feed',
            onSearch: () => goToArticleSearch(context),
          ),
        ],
        body: ArticleRefreshLazyList(
          controller: pagingController,
          onRequest: repository.getArticles,
          onRefresh: repository.fetchAllSources,
        ),
      ),
      floatingActionButton: BackToTop(
        show: showBackToTop,
        onPressed: backToTop,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
