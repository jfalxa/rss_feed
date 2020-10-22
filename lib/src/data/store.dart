import 'package:flutter/foundation.dart';
import 'package:rss_feed/src/utils/parser.dart';

import 'models.dart';

class Store extends ChangeNotifier {
  Future loader;

  List<Subscription> _subscriptions = [];
  List<Article> _articles = [];
  List<SubscriptionAndArticle> _subscriptionsAndArticles = [];

  bool hasArticle(Article a) {
    return _articles.any((b) => b.guid == a.guid);
  }

  bool hasSubscription(Subscription s) {
    return _subscriptions.any((b) => b.url == s.url);
  }

  bool hasSubscriptionAndArticle(Subscription s, Article a) {
    return _subscriptionsAndArticles
        .any((sa) => sa.subscriptionUrl == s.url && sa.articleGuid == a.guid);
  }

  void addSubscription(Subscription s) async {
    if (!hasSubscription(s)) {
      _subscriptions.add(s);
    }
  }

  void addArticle(Article a) {
    if (!hasArticle(a)) {
      _articles.add(a);
    }
  }

  void addSubscriptionAndArticle(Subscription s, Article a) {
    if (!hasSubscriptionAndArticle(s, a)) {
      _subscriptionsAndArticles.add(SubscriptionAndArticle(s.url, a.guid));
    }
  }

  Future<List<Article>> getArticles() {
    if (_articles.length >= 2) {
      _articles.sort((a, b) => b.date.compareTo(a.date));
    }

    return Future.delayed(Duration(seconds: 1), () => _articles);
  }

  Future<List<Article>> getSubscriptionArticles(Subscription s) {
    var subscriptionArticles = _subscriptionsAndArticles
        .where((sa) => sa.subscriptionUrl == s.url)
        .map((sa) => _articles.firstWhere((a) => a.guid == sa.articleGuid))
        .toList();

    if (subscriptionArticles.length >= 2) {
      subscriptionArticles.sort((a, b) => b.date.compareTo(a.date));
    }

    return Future.delayed(Duration(seconds: 1), () => subscriptionArticles);
  }

  Future<List<Subscription>> getSubscriptions() {
    if (_subscriptions.length >= 2) {
      _subscriptions.sort((a, b) => b.title.compareTo(a.title) ?? 0);
    }

    return Future.delayed(Duration(seconds: 1), () => _subscriptions);
  }

  Future refreshSubscription(Subscription s) async {
    var document = await FeedDocument.fetchAndParse(s.url);

    if (document != null) {
      document.articles.forEach((a) {
        addArticle(a);
        addSubscriptionAndArticle(s, a);
      });
    }
  }

  Future refreshAllSubscriptions() async {
    loader = Future.wait(_subscriptions.map(refreshSubscription));
    notifyListeners();
    await loader;
    return true;
  }
}
