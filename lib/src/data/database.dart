import 'package:rss_feed/src/data/models.dart';
import 'package:sqflite/sqflite.dart';

const SOURCE = 'source';
const ARTICLE = 'article';
const SOURCE_AND_ARTICLE = 'source_and_article';

const S_URL = 'url';
const S_TITLE = 'title';
const S_WEBSITE = 'website';
const S_DESCRIPTION = 'description';
const S_ICON = 'icon';

const A_GUID = 'guid';
const A_TITLE = 'title';
const A_LINK = 'link';
const A_DESCRIPTION = 'description';
const A_IMAGE = 'image';
const A_DATE = 'date';
const A_IS_BOOKMARKED = 'is_bookmarked';

const S_A_SOURCE_URL = 'source_url';
const S_A_ARTICLE_GUID = 'article_guid';

Map<String, dynamic> saMap(Source s, Article a) {
  return SourceAndArticle(s, a).toMap();
}

class FeedDatabase {
  static Database _database;
  static FeedDatabase _instance = FeedDatabase._internal();

  FeedDatabase._internal();

  factory FeedDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }

    return _database;
  }

  Future<Database> _initDatabase() {
    return openDatabase('my_db.db', version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    return db.transaction((txn) async {
      await _createSourceTable(txn);
      await _createArticleTable(txn);
      await _createSourceAndArticleTable(txn);
    });
  }

  Future _createSourceTable(Transaction txn) {
    final query = '''
      CREATE TABLE $SOURCE (
        $S_URL TEXT PRIMARY KEY,
        $S_WEBSITE TEXT,
        $S_TITLE TEXT,
        $S_DESCRIPTION TEXT,
        $S_ICON TEXT
      )
    ''';

    return txn.execute(query);
  }

  Future _createArticleTable(Transaction txn) {
    final query = '''
      CREATE TABLE $ARTICLE (
        $A_GUID TEXT PRIMARY KEY,
        $A_TITLE TEXT,
        $A_LINK TEXT,
        $A_DESCRIPTION TEXT,
        $A_IMAGE TEXT,
        $A_DATE TEXT,
        $A_IS_BOOKMARKED INTEGER
      )
    ''';

    return txn.execute(query);
  }

  Future _createSourceAndArticleTable(Transaction txn) {
    final query = '''
      CREATE TABLE $SOURCE_AND_ARTICLE (
        $S_A_SOURCE_URL TEXT,
        $S_A_ARTICLE_GUID TEXT,
        FOREIGN KEY ($S_A_SOURCE_URL) REFERENCES $SOURCE($S_URL),
        FOREIGN KEY ($S_A_ARTICLE_GUID) REFERENCES $ARTICLE($A_GUID),
        PRIMARY KEY ($S_A_SOURCE_URL, $S_A_ARTICLE_GUID)
      )
    ''';

    return txn.execute(query);
  }

  Future<List<Source>> getSources() async {
    final db = await database;
    final sources = await db.query(SOURCE, orderBy: "$S_TITLE");
    return sources.map((s) => Source.fromMap(s)).toList();
  }

  Future<List<Article>> getArticles() async {
    final db = await database;
    final articles = await db.query(ARTICLE, orderBy: "$A_DATE DESC");
    return articles.map((a) => Article.fromMap(a)).toList();
  }

  Future<List<Article>> getSourceArticles(Source s) async {
    final query = '''
      SELECT * 
      FROM $ARTICLE 
      WHERE $A_GUID IN (
        SELECT $S_A_ARTICLE_GUID 
        FROM $SOURCE_AND_ARTICLE 
        WHERE $S_A_SOURCE_URL = ?
      )
      ORDER BY $A_DATE DESC
    ''';

    final db = await database;
    final sourceArticles = await db.rawQuery(query, [s.url]);
    return sourceArticles.map((a) => Article.fromMap(a)).toList();
  }

  Future<List<Article>> getBookmarkedArticles() async {
    final db = await database;
    final where = "$A_IS_BOOKMARKED = 1";
    final bookmarkedArticles = await db.query(ARTICLE, where: where);
    return bookmarkedArticles.map((a) => Article.fromMap(a)).toList();
  }

  Future addSource(Source s) async {
    return (await database)
        .insert(SOURCE, s.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future addSourceArticles(Source s, List<Article> aa) async {
    return (await database).transaction((txn) async {
      var batch = txn.batch();

      aa.forEach((a) => batch.insert(ARTICLE, a.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore));

      aa.forEach((a) => batch.insert(SOURCE_AND_ARTICLE, saMap(s, a),
          conflictAlgorithm: ConflictAlgorithm.ignore));

      return batch.commit();
    });
  }

  Future addBookmark(Article a) async {
    return (await database).update(ARTICLE, {A_IS_BOOKMARKED: 1},
        where: '$A_GUID = ?', whereArgs: [a.guid]);
  }

  Future removeBookmark(Article a) async {
    return (await database).update(ARTICLE, {A_IS_BOOKMARKED: 0},
        where: '$A_GUID = ?', whereArgs: [a.guid]);
  }
}
