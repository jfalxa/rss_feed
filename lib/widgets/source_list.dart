import 'package:flutter/material.dart';

import '../models/source.dart';
import './source_list_item.dart';
import './separator.dart';
import './loader.dart';

class SourceList extends StatelessWidget {
  final List<Source> _sources;
  final Function(Source) _onTap;
  final Function(Source) _onRemove;

  SourceList({
    Key key,
    List<Source> sources,
    Function(Source) onTap,
    Function(Source) onRemove,
  })  : _sources = sources,
        _onTap = onTap,
        _onRemove = onRemove,
        super(key: key);

  // immediately remove source from list to avoid bugs with Dismissible widget
  _removeSource(Source s) {
    _sources.remove(s);
    _onRemove(s);
  }

  @override
  Widget build(BuildContext context) {
    if (_sources.length == 0) {
      return Center(child: Text('No sources found.'));
    }

    return ListView.separated(
      itemCount: _sources.length,
      padding: EdgeInsets.all(0),
      separatorBuilder: separatorBuilder,
      itemBuilder: (context, i) => SourceListItem(
        source: _sources[i],
        onTap: _onTap,
        onRemove: _onRemove == null ? null : _removeSource,
      ),
    );
  }
}

class FutureSourceList extends StatelessWidget {
  final Future<List<Source>> _sources;
  final Function(Source) _onTap;
  final Function(Source) _onRemove;

  FutureSourceList({
    Key key,
    Future<List<Source>> sources,
    Function(Source) onTap,
    Function(Source) onRemove,
  })  : _sources = sources,
        _onTap = onTap,
        _onRemove = onRemove,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<Source>>(
      future: _sources,
      error: 'Error getting sources from database',
      builder: (context, sources) => SourceList(
        sources: sources,
        onTap: _onTap,
        onRemove: _onRemove,
      ),
    );
  }
}