import 'package:flutter/foundation.dart';
import 'package:rss_feed/src/data/database.dart';
import 'package:rss_feed/src/utils/parser.dart';

import 'models.dart';

class Repository extends ChangeNotifier {
  FeedDatabase _database = FeedDatabase();
  Future loader;

  Repository() {
    loader = refreshAllSources();
  }

  Future addSource(Source s) {
    return _database.addSource(s);
  }

  Future addSourceArticles(Source s, List<Article> aa) {
    return _database.addSourceArticles(s, aa);
  }

  Future<List<Source>> getSources() {
    return _database.getSources();
  }

  Future<List<Article>> getArticles() {
    return _database.getArticles();
  }

  Future<List<Article>> getSourceArticles(Source s) {
    return _database.getSourceArticles(s);
  }

  Future refreshSource(Source s) async {
    var document = await FeedDocument.fetchAndParse(s.url);

    if (document != null) {
      addSourceArticles(s, document.articles);
    }
  }

  Future refreshAllSources() async {
    var sources = await getSources();
    loader = Future.wait(sources.map(refreshSource));
    notifyListeners();
    await loader;
    return true;
  }
}
