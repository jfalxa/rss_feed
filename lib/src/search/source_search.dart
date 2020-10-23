import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../routes/source_feed.dart';
import '../widgets/loader.dart';
import '../widgets/source_list.dart';
import 'search.dart';

class SourceSearch extends Search<Source> {
  void _goToSourceFeed(BuildContext context, Source source) {
    Navigator.pushNamed(context, SourceFeed.routeName, arguments: source);
  }

  @override
  Widget buildResults(BuildContext context) {
    var repository = Provider.of<Repository>(context);

    return Loader<List<Source>>(
      future: repository.findSources(this.query),
      error: "Error searching for sources",
      builder: (context, sources) => SourceList(
        sources: sources,
        onTap: (source) => _goToSourceFeed(context, source),
      ),
    );
  }
}
