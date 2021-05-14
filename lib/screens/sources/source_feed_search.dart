import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../models/source.dart';
import '../../services/repository.dart';
import '../../widgets/article_list.dart';
import '../../widgets/search.dart';

class SourceFeedSearch extends Search<Article> {
  final Source source;

  SourceFeedSearch({@required this.source}) : super();

  @override
  Widget buildResults(BuildContext context) {
    var repository = context.read<Repository>();

    return LazyArticleList(
      controller: controller,
      onRequest: (l, o) => repository.findSourceArticles(source, query, l, o),
    );
  }
}
