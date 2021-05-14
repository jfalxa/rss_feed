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
  bool _showBackToTop = false;

  final ScrollController _scrollController = ScrollController();
  final PagingController<int, Article> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  initState() {
    super.initState();

    _scrollController.addListener(() {
      var position = _scrollController.position.pixels;
      var max = _scrollController.position.maxScrollExtent;

      if (!_showBackToTop && position >= max) {
        setState(() {
          _showBackToTop = true;
        });
      } else if (_showBackToTop && position < max) {
        setState(() {
          _showBackToTop = false;
        });
      }
    });
  }

  void _backToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
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

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          TopBar(
            title: 'Feed',
            onSearch: () => _goToArticleSearch(context),
          ),
        ],
        body: ArticleRefreshLazyList(
          controller: _pagingController,
          onRequest: repository.getArticles,
          onRefresh: repository.fetchAllSources,
        ),
      ),
      floatingActionButton: BackToTop(
        show: _showBackToTop,
        onPressed: _backToTop,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
