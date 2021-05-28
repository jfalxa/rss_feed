import 'package:sqflite/sqflite.dart';

import '../models/article.dart';
import '../models/source.dart';
import '../models/source_article.dart';
import '../services/scraper.dart';

class Repository {
  final Scraper _scraper = Scraper();

  late final Future<Database> _db;
  late final SourceDao _sources;
  late final ArticleDao _articles;
  late final SourceAndArticleDao _sourcesAndArticles;

  Repository() {
    _db = initDatabase();
    _sources = SourceDao(db: _db);
    _articles = ArticleDao(db: _db);
    _sourcesAndArticles = SourceAndArticleDao(db: _db);
  }

  static Future<Database> initDatabase() {
    return openDatabase(
      'feed.db',
      version: 1,
      onCreate: (Database db, int version) => db.transaction((tx) async {
        await SourceDao.createSourceTable(tx);
        await ArticleDao.createArticleTable(tx);
        await SourceAndArticleDao.createSourceAndArticleTable(tx);
      }),
    );
  }

  Future<List<Source>> searchSources(String query) {
    return _scraper.search(query);
  }

  Future createSource(Source source) async {
    await _sources.addSource(source);
    await fetchSource(source);
  }

  Future fetchSource(Source source) async {
    final feed = await _scraper.fetch(source.url);

    if (feed != null) {
      await (await _db).transaction((tx) async {
        await _articles.addArticles(feed.articles, tx);
        await _sourcesAndArticles.addSourceArticles(tx, source, feed.articles);
      });
    }
  }

  Future fetchAllSources() async {
    final sources = await getSources();
    final waiting = sources.map(fetchSource);
    return Future.wait(waiting);
  }

  Future forgetSource(Source source) async {
    return (await _db).transaction((tx) async {
      await _sources.removeSource(source, tx);
      await _sourcesAndArticles.removeSourcesAndArticles(tx, source);
      await _sourcesAndArticles.removeOrphanArticles(tx);
    });
  }

  Future<List<Source>> getSources([int? limit, int? offset]) {
    return _sources.getSources(limit, offset);
  }

  Future<List<Source>> findSources(String query, int limit, int offset) {
    return _sources.findSources(query, limit, offset);
  }

  Future<List<Article>> getArticles(int limit, int offset) {
    return _articles.getArticles(limit, offset);
  }

  Future<List<Article>> findArticles(String query, int limit, int offset) {
    return _articles.findArticles(query, limit, offset);
  }

  Future<bool> toggleBookmark(Article article, [bool? toggle]) {
    return _articles.toggleBookmark(article, toggle);
  }

  Future<List<Article>> getBookmarks(int limit, int offset) {
    return _articles.getBookmarks(limit, offset);
  }

  Future<List<Article>> findBookmarks(String query, int limit, int offset) {
    return _articles.findBookmarks(query, limit, offset);
  }

  Future<List<Article>> getSourceArticles(
      Source source, int limit, int offset) {
    return _sourcesAndArticles.getSourceArticles(source, limit, offset);
  }

  Future<List<Article>> findSourceArticles(
      Source source, String query, int limit, int offset) {
    return _sourcesAndArticles.findSourceArticles(source, query, limit, offset);
  }
}
