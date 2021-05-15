import 'package:flutter/material.dart';

class ArticleImage extends StatelessWidget {
  final String? _url;

  ArticleImage({Key? key, String? url})
      : _url = url,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_url != null) {
      return Image.network(
        _url!,
        width: 72.0,
        height: 72.0,
        fit: BoxFit.cover,
      );
    }

    final dummyUrl = Theme.of(context).brightness == Brightness.dark
        ? 'assets/images/dummy-image-dark.jpg'
        : 'assets/images/dummy-image.jpg';

    return Image.asset(
      dummyUrl,
      width: 72.0,
      height: 72.0,
    );
  }
}
