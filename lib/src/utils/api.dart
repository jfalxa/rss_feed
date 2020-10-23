import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../data/models.dart';
import 'redirects.dart';

class Api {
  static final feedRx = RegExp(r'rss|xml');
  static final root = 'https://cloud.feedly.com/v3';

  static Source toSource(Map<String, dynamic> json) {
    var url = json['website'].contains(feedRx)
        ? json['website']
        : json['feedId'].substring(5);

    return Source(
      url: url,
      website: json['website'],
      title: json['title'],
      description: json['description'],
      icon: json['iconUrl'],
    );
  }

  static Future<List<Source>> searchSources(String query) async {
    if (query == '') return Future.value([]);

    var response = await http.get('$root/search/feeds?query=$query');
    var json = convert.jsonDecode(response.body);

    var results = List<Map<String, dynamic>>.from(json['results']);
    var sources = results.map(toSource).toList();

    var resolving = sources.map((s) async {
      s.url = await resolveRedirects(s.url);
    });

    await Future.wait(resolving);
    sources.removeWhere((s) => s.url == null);

    return sources;
  }

  static Future<Source> getSource(String url) async {
    return searchSources(url).then((list) => list.first);
  }
}
