import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../data/models.dart';

class SourceListItem extends StatelessWidget {
  final Source _source;
  final Function _onTap;

  SourceListItem({Key key, Source source, Function onTap})
      : _source = source,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(_source),
      child: Container(
        padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
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
                    _source.title ?? 'Source',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4.0, bottom: 16.0),
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
}
