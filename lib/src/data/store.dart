import 'models.dart';

class Store {
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

  void addSubscription(Subscription addedSubscription) {
    if (!hasSubscription(addedSubscription)) {
      _subscriptions.add(addedSubscription);
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
    _subscriptions.removeWhere((s) => s == null);

    if (_subscriptions.length >= 2) {
      _subscriptions.sort((a, b) => b.title?.compareTo(a.title) ?? 0);
    }

    return _subscriptions;
  }

  Future refreshSubscriptions() async {
    var futures = _subscriptions.map((s) => s.fetch());
    var documents = await Future.wait(futures);

    documents.forEach((document) {
      if (document != null) {
        addArticles(document.articles);
      }
    });

    return documents;
  }
}
