import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_feed/src/data/models.dart';

import '../data/repository.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';

class SourceFeed extends StatelessWidget {
  static final String routeName = '/source-feed';

  @override
  Widget build(BuildContext context) {
    Source source = ModalRoute.of(context).settings.arguments;

    return Consumer<Repository>(
      builder: (context, repository, child) => Scaffold(
        appBar: PopTopBar(title: source.title),
        body: FutureArticleList(
          articles: repository.getSourceArticles(source),
          onRefresh: repository.refreshAllSources,
        ),
      ),
    );
  }
}
