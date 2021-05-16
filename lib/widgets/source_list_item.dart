import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../models/source.dart';

class SourceListItem extends StatelessWidget {
  final Source _source;
  final Function(Source) _onTap;
  final Function(Source)? _onRemove;

  SourceListItem({
    Key? key,
    required Source source,
    required Function(Source) onTap,
    Function(Source)? onRemove,
  })  : _source = source,
        _onTap = onTap,
        _onRemove = onRemove,
        super(key: key);

  Future<bool?> _askRemoveSource(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: _buildAlert,
    );
  }

  void _removeSource() {
    try {
      if (_onRemove != null) {
        _onRemove!(_source);
      }
    } catch (err) {
      print('Error removing source: $err');
    }
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _source.url));

    final snackbar = SnackBar(
      content: Text("Link copied!", textAlign: TextAlign.center),
      width: 108,
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
      content: Text('Do you want to remove "${_source.title}"?'),
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
    var image = _source.icon != null
        ? CircleAvatar(backgroundImage: NetworkImage(_source.icon!))
        : CircleAvatar(child: Text(_source.title[0].toUpperCase()));

    return InkWell(
      onTap: () => _onTap(_source),
      onLongPress: () => _copyLink(context),
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
      background: _buildDismissBackground(context, true),
      secondaryBackground: _buildDismissBackground(context, false),
      confirmDismiss: (direction) => _askRemoveSource(context),
      onDismissed: (direction) => _removeSource(),
      child: _buildItem(context),
    );
  }
}
