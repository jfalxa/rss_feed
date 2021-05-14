import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/source.dart';

class SourceListItem extends StatelessWidget {
  final Source source;
  final Function(Source) onTap;
  final Function(Source) onRemove;

  SourceListItem({
    Key key,
    this.source,
    this.onTap,
    this.onRemove,
  }) : super(key: key);

  Future<bool> _askToRemoveSource(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: _buildAlert,
    );
  }

  Widget _buildDismissBackground(BuildContext context, bool isMain) {
    return Container(
      alignment: isMain ? Alignment.centerLeft : Alignment.centerRight,
      color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Icon(Icons.delete_forever, color: Colors.white),
    );
  }

  Widget _buildAlert(BuildContext context) {
    return AlertDialog(
      title: Text('Remove source'),
      content: Text('Do you want to remove "${source.title}"?'),
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
    var image = source.icon != null
        ? CircleAvatar(backgroundImage: NetworkImage(source.icon))
        : CircleAvatar(child: Text(source.title[0].toUpperCase()));

    return InkWell(
      onTap: () => onTap(source),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: image,
              margin: EdgeInsets.only(right: 16.0),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    source.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Text(
                      source.url,
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
    if (onRemove == null) {
      return _buildItem(context);
    }

    return Dismissible(
      key: Key(source.url),
      background: _buildDismissBackground(context, true),
      secondaryBackground: _buildDismissBackground(context, false),
      confirmDismiss: (direction) => _askToRemoveSource(context),
      onDismissed: (direction) => onRemove(source),
      child: _buildItem(context),
    );
  }
}
