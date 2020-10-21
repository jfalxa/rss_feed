import 'package:http/http.dart' as http;

import 'models.dart';
import 'parser.dart';

class Store {
  Map<String, Subscription> _subscriptions;
  List<Article> _articles;

  Store(Map<String, Subscription> subscriptions, List<Article> articles)
      : _subscriptions = Map.from(subscriptions),
        _articles = articles;

  bool hasArticle(Article a) {
    return _articles.any((b) => b.guid == a.guid);
  }

  bool hasSubscription(Subscription s) {
    return _subscriptions.containsKey(s.url);
  }

  void addSubscription(Subscription addedSubscription) {
    if (!hasSubscription(addedSubscription)) {
      _subscriptions[addedSubscription.url] = addedSubscription;
    }
  }

  void addArticles(List<Article> articles) {
    _articles.addAll(articles.where((a) => !hasArticle(a)));
  }

  List<Article> getArticles() {
    if (_articles.length >= 2) {
      _articles.sort((a, b) => b.date.compareTo(a.date));
    }

    return _articles;
  }

  List<Article> getSubscriptionArticles(Subscription s) {
    var articles = _articles.where((a) => a.subscriptionUrl == s.url).toList();

    if (articles.length >= 2) {
      articles.sort((a, b) => b.date.compareTo(a.date));
    }

    return articles;
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
      addSubscription(document.subscription);
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
