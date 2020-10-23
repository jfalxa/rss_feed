import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../data/models.dart';

class SourceListItem extends StatelessWidget {
  final Source _source;
  final Function(Source) _onTap;
  final Function(Source) _onRemove;

  SourceListItem({
    Key key,
    Source source,
    Function(Source) onTap,
    Function(Source) onRemove,
  })  : _source = source,
        _onTap = onTap,
        _onRemove = onRemove,
        super(key: key);

  Future<bool> _askToRemoveSource(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: _buildAlert,
    );
  }

  Widget _buildAlert(BuildContext context) {
    return AlertDialog(
      title: Text('Remove source'),
      content: Text('Do you want to remove the source "${_source.title}"?'),
      actions: <Widget>[
        TextButton(
          child: Text('NO'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text('YES'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(_source),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: CircleAvatar(),
              margin: EdgeInsets.only(right: 16.0),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _source.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Text(
                      _source.url,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_onRemove == null) {
      return _buildItem(context);
    }

    return Dismissible(
        key: Key(_source.url),
        direction: DismissDirection.startToEnd,
        background: Container(
          alignment: Alignment.centerLeft,
          color: Colors.red,
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.delete_forever, color: Colors.white),
        ),
        confirmDismiss: (direction) => _askToRemoveSource(context),
        onDismissed: (direction) => _onRemove(_source),
        child: _buildItem(context));
  }
}
