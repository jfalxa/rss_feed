import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:webfeed/webfeed.dart';

import '../models/article.dart';
import '../models/source.dart';
import '../models/source_article.dart';

class Repository {
  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDatabase();
    }

    return _db;
  }

  Future<Database> initDatabase() {
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

  Future<List<Article>> getArticles([int limit, int offset]) async {
    return Article.getArticles(await db, limit, offset);
  }

  Future<List<Article>> getSourceArticles(Source s,
      [int limit, int offset]) async {
    return SourceAndArticle.getSourceArticles(await db, s, limit, offset);
  }

  Future<List<Article>> getBookmarks([int limit, int offset]) async {
    return Article.getBookmarks(await db, limit, offset);
  }

  Future<List<Source>> findSources(String query,
      [int limit, int offset]) async {
    return Source.findSources(await db, query, limit, offset);
  }

  Future<List<Article>> findArticles(String query,
      [int limit, int offset]) async {
    return Article.findArticles(await db, query, limit, offset);
  }

  Future<List<Article>> findBookmarks(String query,
      [int limit, int offset]) async {
    return Article.findBookmarks(await db, query, limit, offset);
  }

  Future<List<Article>> findSourceArticles(Source s, String query,
      [int limit, int offset]) async {
    return SourceAndArticle.findSourceArticles(
        await db, s, query, limit, offset);
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

  Future fetchSource(Source s) async {
    String xml = '';
    RssFeed rssFeed;
    AtomFeed atomFeed;

    try {
      var url = Uri.parse(s.url);
      var response = await http.get(url);

      xml = utf8.decode(response.bodyBytes);
    } catch (err) {
      print("Error reading source at ${s.url}: $err");
    }

    try {
      rssFeed = RssFeed.parse(xml);
    } catch (err) {
      rssFeed = null;
    }

    try {
      atomFeed = AtomFeed.parse(xml);
    } catch (err) {
      atomFeed = null;
    }

    try {
      List<Article> articles = [];
      if (rssFeed != null) {
        articles = rssFeed.items.map((a) => Article.fromRss(a)).toList();
      } else if (atomFeed != null) {
        articles = atomFeed.items.map((a) => Article.fromAtom(a)).toList();
      }

      await addSourceArticles(s, articles);
    } catch (err) {
      print("Error adding articles to database: $err");
    }
  }

  Future fetchAllSources() async {
    var sources = await getSources();
    await Future.wait(sources.map(fetchSource));
  }
}
