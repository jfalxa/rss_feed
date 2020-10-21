import 'package:http/http.dart' as http;

import 'models.dart';
import 'parser.dart';

class Store {
  Map<String, Subscription> _subscriptions;
  List<Article> _articles;

  Store(Map<String, Subscription> subscriptions, List<Article> articles)
      : _subscriptions = Map.from(subscriptions),
        _articles = articles;

  void initSubscription(String url) {}

  void addSubscription(String url, Subscription addedSubscription) {
    _subscriptions[url] = addedSubscription;
  }

  void addArticles(List<Article> addedArticles) {
    _articles.addAll(addedArticles);
  }

  List<Article> getArticles() {
    if (_articles.length >= 2) {
      _articles.sort((a, b) => b.date.compareTo(a.date));
    }

    return _articles;
  }

  List<Subscription> getSubscriptions() {
    var subscriptions = _subscriptions.values.toList();
    subscriptions.removeWhere((s) => s == null);
    subscriptions.sort((a, b) => b.title.compareTo(a.title));
    return subscriptions;
  }

  Future refresh() async {
    var futures = _subscriptions.keys.map(fetch);
    var documents = await Future.wait(futures);

    documents.forEach((document) {
      addSubscription(document.url, document.subscription);
      addArticles(document.articles);
    });
  }

  Future<FeedDocument> fetch(String url) async {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    return FeedDocument.parse(url, response.body);
  }
}
