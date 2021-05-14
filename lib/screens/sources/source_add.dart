import 'package:flutter/material.dart';

import '../../models/source.dart';
import '../../services/feedly.dart';
import '../../widgets/loader.dart';
import '../../widgets/source_list.dart';
import '../../widgets/search.dart';

class SourceAdd extends Search<Source> {
  @override
  Widget buildResults(BuildContext context) {
    return Loader<List<Source>>(
      future: Feedly.searchSources(this.query),
      error: 'Error searching for sources',
      builder: (context, sources) => SourceList(
        sources: sources,
        onTap: (s) => close(context, s),
      ),
    );
  }
}
