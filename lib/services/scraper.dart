import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

import '../models/source.dart';
import '../models/article.dart';

class Feed {
  Source? source;
  List<Article>? articles;

  Feed({this.source, this.articles});
}

Future<String?> resolveRedirects(String url) async {
  try {
    var redirectUrl = url;
    var uri = Uri.parse(redirectUrl)..replace(scheme: 'https');

    final client = http.Client();
    final request = http.Request('GET', uri)..followRedirects = false;
    var response = await client.send(request);

    while (response.isRedirect) {
      redirectUrl = response.headers['location'] ?? '';
      uri = Uri.parse(redirectUrl)..replace(scheme: 'https');

      var request = http.Request('GET', uri)..followRedirects = false;
      response = await client.send(request);
    }

    return uri.toString();
  } catch (error) {
    print('Error redirecting feed: $error');
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

  static Future<Feed> fetchFeed(String query) async {
    var f = Feed();

    RssFeed? rss;
    AtomFeed? atom;

    var url = Uri.parse(query);
    var response = await http.get(url);
    var xml = utf8.decode(response.bodyBytes);

    try {
      rss = RssFeed.parse(xml);
    } catch (err) {
      rss = null;
    }

    try {
      atom = AtomFeed.parse(xml);
    } catch (err) {
      atom = null;
    }

    if (rss != null) {
      f.source = Source.fromRss(rss);
      f.articles = rss.items?.map((a) => Article.fromRss(a)).toList() ?? [];
    } else if (atom != null) {
      f.source = Source.fromAtom(atom);
      f.articles = atom.items?.map((a) => Article.fromAtom(a)).toList() ?? [];
    }

    return f;
  }

  static Future<List<Source>> searchSources(String query) async {
    if (query == '') return Future.value([]);

    try {
      var feed = await fetchFeed(query);
      if (feed.source != null) return [feed.source!];
    } catch (err) {/* move on */}

    var url = Uri.parse('$_search?query=$query');
    var response = await http.get(url);
    var json = jsonDecode(response.body);

    var results = List<Map<String, dynamic>>.from(json['results']);
    var sources = results.map(_toSource).toList();

    var resolving = sources.map((s) async {
      s.url = await resolveRedirects(s.url) ?? '';
    });

    await Future.wait(resolving);
    sources.removeWhere((s) => s.url.isEmpty);

    return sources;
  }
}
