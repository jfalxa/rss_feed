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

  Future<List<Article>> getBookmarks() {
    return _database.getBookmarks();
  }

  Future<List<Source>> findSources(String query) {
    return _database.findSources(query);
  }

  Future<List<Article>> findArticles(String query) {
    return _database.findArticles(query);
  }

  Future<List<Article>> findSourceArticles(Source s, String query) {
    return _database.findSourceArticles(s, query);
  }

  Future<List<Article>> findBookmarks(String query) {
    return _database.findBookmarks(query);
  }

  Future removeSource(Source s) async {
    await _database.removeSource(s);
    notifyListeners();
  }

  Future toggleBookmark(Article a) async {
    if (a.isBookmarked) {
      await _database.removeBookmark(a);
    } else {
      await _database.addBookmark(a);
    }

    notifyListeners();
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
