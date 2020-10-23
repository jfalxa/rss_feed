import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repository.dart';
import '../widgets/loader.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => Scaffold(
        appBar: TopBar(title: 'Feed'),
        body: Loader(
          future: repository.loader,
          error: 'Error refreshing articles',
          builder: (context, data) => FutureArticleList(
            articles: repository.getArticles(),
            onRefresh: repository.refreshAllSubscriptions,
          ),
        ),
      ),
    );
  }
}
