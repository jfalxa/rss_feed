import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';

import '../data/store.dart';
import '../widgets/loader.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';

class Bookmarks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
        builder: (context, store, child) => Scaffold(
            appBar: TopBar(title: 'Bookmarks'),
            body: Loader(
                future: store.loader,
                error: 'Error refreshing bookmarks',
                builder: (context, data) => FutureArticleList(
                      articles: store.getArticles(),
                      onRefresh: store.refreshAllSubscriptions,
                    ))));
  }
}
