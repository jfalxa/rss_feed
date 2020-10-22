import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../widgets/article_list.dart';
import '../widgets/top_bar.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
        builder: (context, store, child) => Scaffold(
            appBar: TopBar(title: "Feed"),
            body: ArticleList(
              loader: store.loader,
              articles: store.getArticles(),
              onRefresh: store.refreshAllSubscriptions,
            )));
  }
}
