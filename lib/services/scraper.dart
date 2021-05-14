import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

import '../models/source.dart';
import '../models/article.dart';

Future<String> resolveRedirects(String url) async {
  var redirectUrl = url;

  try {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(redirectUrl))
      ..followRedirects = false;

    var response = await client.send(request);

    while (response.isRedirect) {
      redirectUrl = response.headers['location'];

      var request = http.Request('GET', Uri.parse(redirectUrl))
        ..followRedirects = false;

      response = await client.send(request);
    }

    return redirectUrl;
  } catch (error) {
    print('REDIRECT ERROR: $error');
  }

  return null;
}

class Scraper {
  static final _feedRx = RegExp(r'rss|xml');
  static final _search = 'https://cloud.feedly.com/v3/search/feeds';

  static Source _toSource(Map<String, dynamic> json) {
    var url = json['website'].contains(_feedRx)
        ? json['website']
        : json['feedId'].substring(5);

    return Source(
      url: url,
      website: json['website'],
      title: json['title'],
      description: json['description'],
      icon: json['visualUrl'],
    );
  }

  static Future<List<Source>> searchSources(String query) async {
    if (query == '') return Future.value([]);

    var url = Uri.parse('$_search?query=$query');
    var response = await http.get(url);
    var json = jsonDecode(response.body);

    var results = List<Map<String, dynamic>>.from(json['results']);
    var sources = results.map(_toSource).toList();

    var resolving = sources.map((s) async {
      s.url = await resolveRedirects(s.url);
    });

    await Future.wait(resolving);
    sources.removeWhere((s) => s.url == null);

    return sources;
  }

  static Future<List<Article>> fetchSource(Source s) async {
    String xml = '';
    RssFeed rssFeed;
    AtomFeed atomFeed;

    var url = Uri.parse(s.url);
    var response = await http.get(url);

    xml = utf8.decode(response.bodyBytes);

    try {
      rssFeed = RssFeed.parse(xml);
    } catch (err) {
      rssFeed = null;
    }

    try {
      atomFeed = AtomFeed.parse(xml);
    } catch (err) {
      atomFeed = null;
    }

    List<Article> articles = [];

    if (rssFeed != null) {
      articles = rssFeed.items.map((a) => Article.fromRss(a)).toList();
    } else if (atomFeed != null) {
      articles = atomFeed.items.map((a) => Article.fromAtom(a)).toList();
    }

    return articles;
  }
}
