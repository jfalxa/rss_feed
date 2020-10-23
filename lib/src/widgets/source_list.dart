import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models.dart';
import 'loader.dart';
import 'source_list_item.dart';

class SourceList extends StatelessWidget {
  final List<Source> _sources;
  final Function _onTap;

  SourceList({Key key, List<Source> sources, Function onTap})
      : _sources = sources,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_sources.length == 0) {
      return Center(child: Text("No source available"));
    }

    return ListView.separated(
      itemCount: _sources.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, i) => SourceListItem(
        source: _sources[i],
        onTap: _onTap,
      ),
    );
  }
}

class FutureSourceList extends StatelessWidget {
  final Future<List<Source>> _sources;
  final Function _onTap;

  FutureSourceList({Key key, Future<List<Source>> sources, Function onTap})
      : _sources = sources,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<Source>>(
        future: _sources,
        error: 'Error getting sources from database',
        builder: (context, sources) =>
            SourceList(sources: sources, onTap: _onTap));
  }
}
