import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../models/source.dart';
import '../../services/repository.dart';
import '../../widgets/article_lazy_list.dart';
import '../../widgets/search.dart';

class SourceFeedSearch extends Search<Article> {
  final Source _source;

  SourceFeedSearch({required Source source})
      : _source = source,
        super();

  @override
  Widget buildResults(BuildContext context) {
    var repository = context.read<Repository>();

    return ArticleLazyList(
      controller: controller,
      onRequest: (l, o) => repository.findSourceArticles(_source, query, l, o),
    );
  }
}
