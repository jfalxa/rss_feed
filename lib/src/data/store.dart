import 'package:flutter/foundation.dart';

import 'models.dart';

class Store extends ChangeNotifier {
  Future loader;

  List<Subscription> _subscriptions;
  List<Article> _articles;

  Store(List<Subscription> subscriptions, List<Article> articles)
      : _subscriptions = subscriptions,
        _articles = articles;

  bool hasArticle(Article a) {
    return _articles.any((b) => b.guid == a.guid);
  }

  bool hasSubscription(Subscription s) {
    return _subscriptions.any((b) => b.url == s.url);
  }

  void addSubscription(Subscription subscription) async {
    if (!hasSubscription(subscription)) {
      _subscriptions.add(subscription);
    }
  }

  void addArticles(List<Article> articles) {
    _articles.addAll(articles.where((a) => !hasArticle(a)));
  }

  Future<List<Article>> getArticles() {
    if (_articles.length >= 2) {
      _articles.sort((a, b) => b.date.compareTo(a.date));
    }

    return Future.delayed(Duration(seconds: 1), () => _articles);
  }

  Future<List<Article>> getSubscriptionArticles(Subscription s) {
    var subscriptionArticles =
        _articles.where((a) => a.subscriptionUrl == s.url).toList();

    if (subscriptionArticles.length >= 2) {
      subscriptionArticles.sort((a, b) => b.date.compareTo(a.date));
    }

    return Future.delayed(Duration(seconds: 1), () => subscriptionArticles);
  }

  Future<List<Subscription>> getSubscriptions() {
    _subscriptions.removeWhere((s) => s == null);

    if (_subscriptions.length >= 2) {
      _subscriptions.sort((a, b) => b.title.compareTo(a.title) ?? 0);
    }

    return Future.delayed(Duration(seconds: 1), () => _subscriptions);
  }

  Future refreshSubscription(Subscription subscription) async {
    var document = await subscription.fetch();

    if (document != null) {
      addArticles(document.articles);
      return true;
    }

    return false;
  }

  Future refreshAllSubscriptions() async {
    loader = Future.wait(_subscriptions.map(refreshSubscription));
    var results = await loader;
    notifyListeners();
    return results;
  }
}
