import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/api.dart';
import '../data/models.dart';
import '../widgets/loader.dart';
import '../widgets/source_list.dart';

class SourceApiSearch extends SearchDelegate<Source> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: Colors.black87,
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black87,
      onPressed: () => close(context, null),
    );
  }

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
