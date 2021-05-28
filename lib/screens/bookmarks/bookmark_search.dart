import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/article_lazy_list.dart';
import '../../widgets/empty_indicator.dart';
import '../../widgets/search.dart';

class BookmarkSearch extends Search<Article> {
  @override
  Widget buildResults(BuildContext context) {
    final repository = context.read<Repository>();

    return ArticleLazyList(
      controller: controller,
      onRequest: (l, o) => repository.findBookmarks(query, l, o),
      emptyBuilder: (context) => EmptyIndicator(title: 'No bookmark found.'),
    );
  }
}
