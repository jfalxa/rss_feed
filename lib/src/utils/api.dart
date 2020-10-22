import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../data/models.dart';
import 'redirects.dart';

class Api {
  static final String root = 'https://cloud.feedly.com/v3';

  static Future<List<Subscription>> searchSubscriptions(String query) async {
    if (query == '') return Future.value([]);

    var response = await http.get('$root/search/feeds?query=$query');
    var json = convert.jsonDecode(response.body);

    List<dynamic> results = json['results'];
    List<Subscription> subscriptions =
        results.map((data) => Subscription.fromJson(data)).toList();

    var resolving = subscriptions.map((s) async {
      s.url = await resolveRedirects(s.url);
    });

    await Future.wait(resolving);
    subscriptions.removeWhere((s) => s.url == null);

    return subscriptions;
  }

  static Future<Subscription> getSubscription(String url) async {
    return searchSubscriptions(url).then((list) => list.first);
  }
}
