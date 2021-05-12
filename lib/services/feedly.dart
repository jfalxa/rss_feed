import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../models/source.dart';

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

class Feedly {
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
      icon: json['visualUrl'],
    );
  }

  static Future<List<Source>> searchSources(String query) async {
    if (query == '') return Future.value([]);

    var url = Uri.parse('$root/search/feeds?query=$query');
    var response = await http.get(url);
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