import 'package:flutter/material.dart';

import '../utils/api.dart';
import '../data/models.dart';
import '../widgets/loader.dart';
import '../widgets/source_list.dart';
import 'search.dart';

class SourceApiSearch extends Search<Source> {
  @override
  Widget buildResults(BuildContext context) {
    return Loader<List<Source>>(
      future: Api.searchSources(this.query),
      error: 'Error searching for sources',
      builder: (context, sources) => SourceList(
        sources: sources,
        onTap: (s) => close(context, s),
      ),
    );
  }
}
