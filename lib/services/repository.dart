import 'package:sqflite/sqflite.dart';

import '../models/article.dart';
import '../models/source.dart';
import '../models/source_article.dart';
import './scraper.dart';

class Repository {
  static Database _db;

  static Future<Database> initDatabase() {
    return openDatabase(
      'feed.db',
      version: 1,
      onCreate: (Database db, int version) => db.transaction((tx) async {
        await Source.createTable(tx);
        await Article.createTable(tx);
        await SourceAndArticle.createTable(tx);
      }),
    );
  }

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDatabase();
    }

    return _db;
  }

  Future addSource(Source s) async {
    return Source.addSource(await db, s);
  }

  Future addSourceArticles(Source s, List<Article> al) async {
    return (await db).transaction((tx) async {
      await Article.addArticles(tx, al);
      await SourceAndArticle.addSourceArticles(tx, s, al);
    });
  }

  Future<List<Source>> getSources([int limit, int offset]) async {
    return Source.getSources(await db, limit, offset);
  }

  Future<Article> getArticle(String guid) async {
    return Article.getArticle(await db, guid);
  }

  Future<List<Article>> getArticles(int limit, int offset) async {
    return Article.getArticles(await db, limit, offset);
  }

  Future<List<Article>> getSourceArticles(
    Source s,
    int limit,
    int offset,
  ) async {
    return SourceAndArticle.getSourceArticles(await db, s, limit, offset);
  }

  Future<List<Article>> getBookmarks(int limit, int offset) async {
    return Article.getBookmarks(await db, limit, offset);
  }

  Future<List<Source>> findSources(
    String query,
    int limit,
    int offset,
  ) async {
    return Source.findSources(await db, query, limit, offset);
  }

  Future<List<Article>> findArticles(
    String query,
    int limit,
    int offset,
  ) async {
    return Article.findArticles(await db, query, limit, offset);
  }

  Future<List<Article>> findBookmarks(
    String query,
    int limit,
    int offset,
  ) async {
    return Article.findBookmarks(await db, query, limit, offset);
  }

  Future<List<Article>> findSourceArticles(
    Source source,
    String query,
    int limit,
    int offset,
  ) async {
    return SourceAndArticle.findSourceArticles(
      await db,
      source,
      query,
      limit,
      offset,
    );
  }

  Future removeSource(Source s) async {
    return (await db).transaction((tx) async {
      await Source.removeSource(tx, s);
      await SourceAndArticle.removeSourceAndArticle(tx, s);
      await Article.removeOrphans(tx);
    });
  }

  Future<bool> toggleBookmark(String guid) async {
    Article article = await getArticle(guid);

    if (article.isBookmarked) {
      await Article.removeBookmark(await db, article);
    } else {
      await Article.addBookmark(await db, article);
    }

    return !article.isBookmarked;
  }

  Future<List<Source>> searchSources(String query) {
    return Scraper.searchSources(query);
  }

  Future fetchSource(Source s) async {
    var articles = await Scraper.fetchSource(s);
    await addSourceArticles(s, articles);
  }

  Future fetchAllSources() async {
    var sources = await getSources();
    await Future.wait(sources.map(fetchSource));
  }
}
